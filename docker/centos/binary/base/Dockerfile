FROM centos
MAINTAINER Kolla Project (https://launchpad.net/kolla)

# Set up repositories
# This repository provides all dependencies used by RDO OpenStack
RUN yum install -y https://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm
# This repository provides latest packages built from trunk master into RPMs
RUN curl http://trunk.rdoproject.org/centos7/current/delorean.repo -o /etc/yum.repos.d/delorean-current.repo
# This repository provides crux which permits idempotent operation of RDO
RUN curl https://copr.fedoraproject.org/coprs/sdake/crux/repo/epel-7/sdake-crux-epel-7.repo -o /etc/yum.repos.d/sdake-crux-epel-7.repo
# This repository turns off auth in PAM so we can operate on Ubuntu 14.04
RUN curl https://copr.fedoraproject.org/coprs/sdake/pam.noaudit/repo/epel-7/sdake-pam.noaudit-epel-7.repo -o /etc/yum.repos.d/sdake-pam.noaudit-epel-7.repo

# CentOS 7.1 workaround for conflicting packages with libvirt
RUN rpm -e --nodeps systemd-container systemd-container-libs
RUN rpm -e --nodeps yum-plugin-fastestmirror
RUN yum -d 10 -y install systemd systemd-libs systemd-devel && yum clean all

RUN yum install -y epel-release && yum clean all

# Update packages
RUN yum update -y && yum clean all

# Install base packages
RUN yum install -y \
        crux \
        mariadb \
        mariadb-libs \
        openssl \
        openstack-utils \
        pyparsing \
        python-alembic \
        python-amqp \
        python-amqplib \
        python-anyjson \
        python-boto \
        python-cheetah \
        python-cliff \
        python-cmd2 \
        python-croniter \
        python-crypto \
        python-d2to1 \
        python-docutils \
        python-dogpile-cache \
        python-dogpile-core \
        python-empy \
        python-eventlet \
        python-flask \
        python-futures \
        python-greenlet \
        python-httplib2 \
        python-iso8601 \
        python-itsdangerous \
        python-jinja2 \
        python-jsonpatch \
        python-jsonpath-rw \
        python-jsonpointer \
        python-jsonschema \
        python-keyring \
        python-kombu \
        python-ldap \
        python-lesscpy \
        python-lockfile \
        python-lxml \
        python-markdown \
        python-memcached \
        python-migrate \
        python-msgpack \
        python-netifaces \
        python-networkx \
        python-oauthlib \
        python-oslo-config \
        python-oslo-messaging \
        python-oslo-rootwrap \
        python-paramiko \
        python-passlib \
        python-paste-deploy \
        python-pbr \
        python-pecan \
        python-ply \
        python-prettytable \
        python-psutil \
        python-pycadf \
        python-pygments \
        python-pymongo \
        python-qpid \
        python-repoze-lru \
        python-requests \
        python-routes \
        python-simplegeneric \
        python-simplejson \
        python-singledispatch \
        python-six \
        python-sqlalchemy \
        python-stevedore \
        python-taskflow \
        python-versiontools \
        python-warlock \
        python-webob \
        python-websockify \
        python-webtest \
        python-werkzeug \
        python-wsme \
        && yum clean all \
        && pip install oslo.service
# TODO(inc0): when oslo_service lands in delorean, change pip to yum
# necessary until https://bugzilla.redhat.com/show_bug.cgi?id=1229477 is fixed

# This is dirty like zebra.  This works around a bug in Ubuntu 14.04 LTS.  The
# --net=host option does not work on ubuntu 14.04 because of a kernel bug.  One
# workaround is to buid pam without authentication.
# See:
#    https://registry.hub.docker.com/u/sequenceiq/pam/
#
RUN rpm -e --nodeps pam
RUN yum -y install pam+noaudit && yum clean all
# End dirty like zebra

RUN mkdir -p /opt/kolla
COPY service_hosts.sh kolla-common.sh /opt/kolla/
