FROM %%KOLLA_NAMESPACE%%/%%KOLLA_PREFIX%%heat-base:%%KOLLA_TAG%%
MAINTAINER Kolla Project (https://launchpad.net/kolla)
# docker run -it -v /var/run/docker.sock:/var/run/docker.sock kollaglue/centos-rdo-heat-standalone /bin/bash

RUN yum -y install openstack-heat-api-cfn \
  python-openstackclient \
  openstack-heat-api \
  openstack-heat-engine \
  python-barbicanclient \
  python-zaqarclient

RUN yum -y install openstack-keystone \
        python-keystoneclient \
        httpd \
        mod_wsgi \
        && yum clean all

RUN yum -y install mariadb \
    mariadb-server \
    MySQL-python \
    hostname \

RUN yum -y install rabbitmq-server hostname

RUN yum -y install supervisor git
# changed to fork to try and avoid constant breakage
RUN git clone https://github.com/jpeeler/kolla.git /opt/kolla/kolla
RUN git clone https://github.com/openstack/heat /opt/heat

COPY standalone.env /opt/kolla/standalone.env
COPY config.sh /opt/kolla/config.sh
