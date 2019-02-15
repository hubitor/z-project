OTUS crawler project

1) Залогиниться в gcloud

2) Проходим в terraform, заполяем terraform.tfvars своими значениями

3) Создаем bucket в GCP (имя remote_bucket) для хранения tfstate - terraform init && terraform apply

4) Разворачиваем инфраструктуру для bare-metall кластера k8s - cd k8s-cluter && terraform apply, По результату имеем 3 ноды контроллеров и 3 ноды воркеров (по-умолчанию,можно изменить
через переменные w_count и c_count), правила маршрутизации, правила firewall, два балансировщика (один для kubeapi, второй для наших сервисов), и одну ноду в качестве NFS-сервера

5) Переходим в папку ../../ansible и настраиваем ./playbooks/vars.yml : имя кластера (условно), ID проекта в GCE, кол-во нод воркеров и контроллеров, имя пользователя и пароль для докерхаба.

6) Объявляем переменную GCS_BUCKET с названием нашего бакета из пункта 3, нужна для работы скрипта dynamic_inventory.py (дергает tfstate из бакета GCP и парсит его для заполнения инвентори).

7) Вносим правки в ansible.cfg (удаленный пользователь, путь к ключу ssh)

8) Запускаем настройку кластера ансиблом (сделано по аналогии с Kubernetes The Hard Way) -  ansible-playbook ./playbooks/site.yml, ждем порядка 7-10 минут :) Важно! файл ~/.kube/config будет перезаписан на конфигурацию для свежесозданного кластера. Так же, в кластер будет установлен CoreDNS и Tiller. Все что нагенерирует ansible (сертификаты, ключи, файлы конфигурации) упадет в 
папку /opt/pki-infrastructure

9) Запускаем настройку NFS-сервера (нужен для Persistent Volumes) - ansible-playbook ./playbooks/site-nfs.yml

10) Разворачиваем Gitlab-Omnibus с помощью Helm - cd ../kubernets/Charts/ && helm install --name gitlab ./gitlab-omnibus/ -f ./gitlab-omnibus/values.yaml

11) Одновременно можно развернуть prometheus и blackbox-exporter: helm install --name prometheus ./prometheus -f ./prometheus/custom_values.yaml && helm install --name blackbox-exporter ./prometheus-blackbox-exporter/ -f ./prometheus-blackbox-exporter/values.yaml

11) Пока инициализируется гитлаб - узнаем external_ip любой из воркер нод и пропимываем его в hosts вида: <external_ip> gitlab-gitlab staging production prometheus

12) Переходим на gitlab и задаем пароль http://gitlab-gitlab, логинемся под рутом и создаем access token для доступа к API: settings-> access tokens

13) Заносим access token в в файл ansibke/playbooks/vars.yml, переменная gitlab_token

14) Запускаем роль настройки gitlab (группа, переменная, проекты, репозитории): cd ../../ansible && ansible-playbook ./playbooks/gitlab_configuration.yml

15) Инициируем тестовый пуш в репозиторий микросервиса, а так же пуш в репозиторий для деплоя, проверяем, что CI/CD работает

16) Базовые метрики доступны по http://prometheus

17) Окружением доступны по http://staging и http://production

18) Если приложение было развернуть в default namespace, то наконец начнет работать балансировщик, находим его IP - gcloud compute forwarding-rules describe kubernetes-forwarding-rule-application --region europe-west1 --format="value(IPAddress)", прописываем в hosts и ходим через LB :-D

