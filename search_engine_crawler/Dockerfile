FROM alpine:3.7

ENV WORK_DIR /app
ENV URL "https://vitkhab.github.io/search_engine_test_site/"
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_USERNAME RMQ_USER
ENV RMQ_PASSWORD RMQ_PASSWORD
ENV RMQ_QUEUE RMQ_QUEUE
ENV EXCLUDE_URLS ".*github.com"

run apk update && apk add python py-pip

COPY . $WORK_DIR

WORKDIR $WORK_DIR

run pip install -r requirements.txt

CMD sleep 10 && python -u ./crawler/crawler.py ${URL}
