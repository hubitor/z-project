default: build_services 

build_services: ./search_engine_crawler/.build_crawler ./search_engine_ui/.build_ui

./search_engine_crawler/.build_crawler: ./search_engine_crawler/Dockerfile ./search_engine_crawler/crawler/*.py
	docker build -t $(USERNAME)/crawler ./search_engine_crawler/ && docker push $(USERNAME)/crawler && touch ./search_engine_crawler/.build_crawler && echo "CRAWLER READY!"

./search_engine_ui/.build_ui: ./search_engine_ui/Dockerfile ./search_engine_ui/ui/*.py
	docker build -t $(USERNAME)/crawler_ui ./search_engine_ui/ && docker push $(USERNAME)/crawler_ui && touch ./search_engine_ui/.build_ui && echo "UI READY!"

./search_engine_crawler/Dockerfile:

./search_engine_ui/Dockerfile:

