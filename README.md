Проектная работа Otus-DevOps-2018-09/Mikhail Scherba

Описание:

В проекте используется облако GCP и сопутствующие утилиты (gcloud).
Для удобства использования была заведена бесплатная DNS зона z-project.tk. Управление зоной было делегированно DNS-хостингу NS1 (в налии удобный API для управления).


Для создания инфраструктуры в облаке GCP используется Terraform.

- Инфра состоит из нод-контроллеров, нод-воркеров, двух http-балансировщиков, одно сервера под NFS.
- При создании инфры можно указывать кол-ва нод с помощью переменных.
- Первый балансировщик используется для доступа к API kubernetes (через nginx).
- Второй балансировщик используется для доступа к Nginx ingress controller.

Для настройки инфрастуруктуры используется Ansible.

- Написаны роли для настройки кластера kubernetes  (bare-metall, по аналогии с the-hard-way).
- Написана роль для настройки простого NFS-сервера для persistentvolume.
- Написана роль для настройки gitlab.
- Написана роль для настройки DNS зоны z-project.tk.
- Для динамического обнаружения хостов в облаке используется самописный скрипт, забирающий и распарсивающий terraform.tfstate из удаленного бакета.

Для развертывания приложений в кластере используется Helm и чарты.

- Чарты вспомогательных служб и приложений, использующие PV, были адаптированы под использование NFS-сервера. 
- PVC приложения Crawler создается только при условии запуска в namespace "production" иначе используется emptyDir.

Для доступа по WEB в кластере используется nginx ingress controller

- Сервис NGINX подов слушает на 80 порту (диапазон NodePort был расширен).
- Для доступа по DNS имени к приложениям используется одна запись вида *.z-project.tk (она же правится через ansible+api при настройки инфтраструктуры). 

Для настройки Gitlab используется ansible+API, а так же 3 подготовленных репозитория.

- https://github.com/miklezzzz/crawler-deploy.git содержит чарты приложения crawler.
- https://github.com/miklezzzz/search_engine_crawler.git содержит код приложения crawler.
- https://github.com/miklezzzz/search_engine_ui содержит код UI приложения crawler.
- В проектах реализованы несложные pipeline (build+test+review для не master веток в отдельных namespace, build+test+release+deploy для master веток через pipeline trigger, деплой в staging/production среды).
- Создаются соотвесвующие gitlab-окружения с возможностью просмотра по URL.

Для мониторинга используется Prometheus + Blackbox Exporter + Node Exporter и тп.

- Реализован мониторинг приложения crawler, b использующихся mongodb и rabbitmq инстансов.
- Написаны пара простых alarm правил с отправкой уведомлений в Slack.
- Реализован мониторинг нод кластера (blackbox + node exporter)

Для визуализации мониторинга используется Grafa.

- Чарт графана настроен с указанием default datasource.
- Добавлены 4 базовых дашборда: метрики приложения crawler, метрики k8s кластера, метрики mongodb, метрики rabbitmq. Дашборды тянутся из репозитория - https://github.com/miklezzzz/grafana_ds.git.

Для логирования используется EFK-стек.


Как запускать:

1) Залогиниться в gcloud (нужен для настройки кластера + DNS зоны).

2) Проходим в terraform, заполяем terraform.tfvars своими значениями.

3) Создаем bucket в GCP (имя remote_bucket) для хранения tfstate - terraform init && terraform apply

4) Разворачиваем инфраструктуру для bare-metall кластера k8s - cd k8s-cluter && terraform apply, По результату имеем 3 ноды контроллеров и 3 ноды воркеров (по-умолчанию, можно изменить
через переменные w_count и c_count), правила маршрутизации, правила firewall, два балансировщика (один для kubeapi, второй для наших сервисов), и одну ноду в качестве NFS-сервера.

5) Переходим в папку ../../ansible и настраиваем ./playbooks/vars.yml : имя кластера (условно), ID проекта в GCE, кол-во нод воркеров и контроллеров, имя пользователя и пароль для докерхаба, токен для API сервиса NS1.

6) Объявляем переменную GCS_BUCKET с названием нашего бакета из пункта 3, нужна для работы скрипта dynamic_inventory.py (дергает tfstate из бакета GCP и парсит его для заполнения инвентори).

7) Вносим правки в ansible.cfg (удаленный пользователь, путь к ключу ssh)

8) Запускаем настройку кластера ансиблом (сделано по аналогии с Kubernetes The Hard Way) -  ansible-playbook ./playbooks/site.yml, ждем порядка 7-10 минут :) Важно! файл ~/.kube/config будет перезаписан на конфигурацию для свежесозданного кластера. Так же, в кластер будет установлен CoreDNS и Tiller. Все что нагенерирует ansible (сертификаты, ключи, файлы конфигурации) упадет в папку /opt/pki-infrastructure.

9) Запускаем настройку NFS-сервера (нужен для Persistent Volumes) - ansible-playbook ./playbooks/site-nfs.yml

10) Запускаем настройку DNS зоны - ansible-playbook ./playbooks/update_dns_records.yml.

11) Разворачиваем Gitlab-Omnibus с помощью Helm - cd ../kubernets/Charts/ && helm install --name gitlab ./gitlab-omnibus/ -f ./gitlab-omnibus/values.yaml

11) Разворачиваем nginx ingress controller с помощью Helm - helm install --name ingress-nginx ./ingress-nginx/ -f ./ingress-nginx/values.yaml

12) Разворачиваем prometheus: helm install --name prometheus ./prometheus -f ./prometheus/custom_values.yaml

13) Переходим на http://gitlab.z-project.tk и задаем пароль root пользователя, логинемся под рутом и создаем access token для доступа к API: settings-> access tokens.

14) Заносим access token в в файл ansible/playbooks/vars.yml, переменная gitlab_token и запускаем роль настройки gitlab (группа, переменная, проекты, репозитории): cd ../../ansible && ansible-playbook ./playbooks/gitlab_configuration.yml

15) Инициируем тестовый пуш в репозиторий микросервиса, а так же пуш в репозиторий для деплоя, проверяем, что CI/CD работает.

16) Разворачиваем grafana: cd ../kubernetes/Charts && helm install --name grafana ./grafana/ -f ./grafana/values.yaml. Переходим на grafana.z-project.tk (admin/otusotus) и проверяем, что datasouce + dashboards присутствуют, графики рисуются.

17) Разворачиваем EFK: helm install --name efk ./EFK/ -f ./EFK/values.yaml. Переходим на kibana.z-project.tk, создаем index fluentd-*, проверяем, что логи собиратся, поле log в логах сервиса crawler парсится и разбивается на дополнительные поля.
