FROM python:2

MAINTAINER paritosh.anand@makemytrip.com

RUN cd /etc/ && rm localtime && ln -s /usr/share/zoneinfo/Asia/Kolkata localtime

RUN apt-get update -y && apt-get install vim -y && apt-get install python-dev -y && apt-get install libldap2-dev -y && apt-get install libsasl2-dev -y && apt-get install python-ldap -y

ADD . /opt

ENV EDGE_MYSQL <MYSQL_SERVER>

ENV EDGE_MYSQL_USER <MYSQL_USER>

ENV EDGE_MYSQL_PASSWORD <MYSQL_PASSWORD>

ENV RABBIT_MQ <RABBIT_MQ_SERVER>

ENV FABRIC_USER_PASSWORD random_pass

WORKDIR /opt/edge

RUN easy_install distribute

RUN pip install -r requirements.txt

RUN mkdir -p /opt/edge/logs && touch /opt/edge/logs/edge.log && touch /opt/edge/logs/console.log

RUN python manage.py migrate

RUN python manage.py createcachetable

RUN python manage.py loaddata action_status.json configs.json env.json plan.json space.json project.json

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
