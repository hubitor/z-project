FROM alpine:3.7

ENV WORK_DIR /app
ENV MONGO mongodb
ENV MONGO_PORT 27017

run apk update && apk add python py-pip

COPY . $WORK_DIR

WORKDIR $WORK_DIR

run pip install -r requirements.txt

CMD cd ui && FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
