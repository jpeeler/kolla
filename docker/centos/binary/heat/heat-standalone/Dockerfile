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
  patch \
  os-collect-config \
  os-refresh-config \
  docker-io \
  && yum clean all \
  && pip install oslo.reports

# changed to fork to try and avoid constant breakage
RUN git clone https://github.com/jpeeler/kolla.git /opt/kolla/kolla
RUN git clone https://github.com/openstack/heat /opt/heat
COPY config.sh standalone.env start-heat-agent.sh dummy-server.yaml stack-create.sh deploy-undercloud.yaml install_docker_agents.yaml heat.patch undercloud-resource.yaml /opt/kolla/
COPY fragments/start_docker_agents.sh /opt/kolla/fragments/start_docker_agents.sh
RUN cat /opt/kolla/heat.patch | (cd /usr/lib/python2.7/site-packages/heat; patch -p1)
