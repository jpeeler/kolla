FROM %%KOLLA_NAMESPACE%%/%%KOLLA_PREFIX%%heat-base:%%KOLLA_TAG%%
MAINTAINER Kolla Project (https://launchpad.net/kolla)
# docker run -it -v /var/run/docker.sock:/var/run/docker.sock kollaglue/centos-rdo-heat-standalone /bin/bash

RUN yum -y install openstack-heat-api-cfn \
  python-openstackclient \
  openstack-heat-api \
  openstack-heat-engine \
  python-barbicanclient \
  python-zaqarclient \
  openstack-keystone \
  python-keystoneclient \
  httpd \
  mod_wsgi \
  mariadb \
  mariadb-server \
  MySQL-python \
  hostname \
  rabbitmq-server \
  supervisor \
  git \
  && yum clean all

# changed to fork to try and avoid constant breakage
RUN git clone https://github.com/jpeeler/kolla.git /opt/kolla/kolla
RUN git clone https://github.com/openstack/heat /opt/heat

COPY config.sh standalone.env stack-create.sh deploy-undercloud.yaml /opt/kolla/
