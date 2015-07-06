#!/bin/bash -x

. standalone.env
pscfg=/etc/supervisord.conf

# linking so all files can access kolla-common.sh
ln -s kolla/docker/common/mariadb-app/mysql-entrypoint.sh
ln -s kolla/docker/common/mariadb-app/config-mysql.sh

ln -s kolla/docker/common/keystone/start.sh keystone-start.sh

ln -s kolla/docker/common/rabbitmq/start.sh rabbit-start.sh
# BUG in Kolla, this should be in common
ln -s kolla/docker/centos/rdo/rabbitmq/config-rabbit.sh config-rabbit.sh
#ln -s kolla/docker/common/rabbitmq/config.sh config-rabbit.sh
cp kolla/docker/common/rabbitmq/rabbitmq-env.conf /etc/rabbitmq
cp kolla/docker/common/rabbitmq/rabbitmq.config /etc/rabbitmq

#JPEELER: can probably be removed now that we're actually basing off heat-base
#ln -s kolla/docker/common/heat/heat-base/config-heat.sh
ln -s kolla/docker/common/heat/heat-api/start.sh heat-api-start.sh
ln -s kolla/docker/common/heat/heat-api-cfn/start.sh heat-api-cfn-start.sh
ln -s kolla/docker/common/heat/heat-engine/start.sh heat-engine-start.sh

# allow builtin changes to be inherited (in some cases?)
export SHELLOPTS

# disable builtin, services will be started with supervisord instead
# scripts that use exec must be source executed!
enable -n exec

#[eventlistener:stdout]
#command = supervisor_stdout
#buffer_size = 100
#events = PROCESS_LOG
#result_handler = supervisor_stdout:event_handler

#under program:
#stderr_events_enabled=true
#stdout_events_enabled=true

#[supervisord]
#nodaemon=true
#logfile = /var/log/supervisor/supervisord.log
#logfile_maxbytes = 200KB
#logfile_backups = 1
#pidfile = /var/run/supervisord.pid
#childlogdir = /var/log/supervisor


# configure mysql
./mysql-entrypoint.sh mysqld_safe
crudini --set $pscfg program:mysql command "mysqld_safe --init-file=/tmp/mysql-first-time.sql"

supervisord -c $pscfg

# hack, would be nice to block until process started instead
sleep 5

# configure keystone
cp /usr/sbin/httpd /usr/sbin/httpd-real
rm -rf /usr/sbin/httpd
ln -s /bin/true /usr/sbin/httpd

# this is hacked out of keystone's dockerfile (should be in start.sh)
mkdir -p /var/www/cgi-bin/keystone
cp -a /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d
sed -i 's,/var/log/apache2,/var/log/httpd,' /etc/httpd/conf.d/wsgi-keystone.conf
sed -i -r 's,^(Listen 80),#\1,' /etc/httpd/conf/httpd.conf
cp -a /usr/share/keystone/keystone.wsgi /var/www/cgi-bin/keystone/main
cp -a /usr/share/keystone/keystone.wsgi /var/www/cgi-bin/keystone/admin
chown -R keystone:keystone /var/www/cgi-bin/keystone
chmod 755 /var/www/cgi-bin/keystone/*

echo 'kill -1 $(<"/var/run/supervisord.pid")' > /usr/sbin/httpd
crudini --set $pscfg program:httpd command "/usr/sbin/httpd-real -DFOREGROUND"

./keystone-start.sh

# configure rabbit
(. rabbit-start.sh)
crudini --set $pscfg program:rabbit command "rabbitmq-server"

# reload supervisord (executes rabbit)
kill -1 $(<"/var/run/supervisord.pid")

# configure heat
./config-heat.sh
(. heat-api-start.sh)
(. heat-api-cfn-start.sh)
(. heat-engine-start.sh)
crudini --set $pscfg program:heat-api command "heat-api"
crudini --set $pscfg program:heat-api-cfn command "heat-api-cfn"
crudini --set $pscfg program:heat-engine command "heat-engine"

crudini --set /etc/heat/heat.conf DEFAULT log_file /var/log/heat/heat-standalone.log

# configure heat docker plugin
pushd /opt/heat/contrib/heat_docker
pip install docker-py # docker-python package installs more dependencies
python setup.py install

# reload supervisord (executes heat)
kill -1 $(<"/var/run/supervisord.pid")

/opt/kolla/kolla/tools/genenv
echo "Heat and dependent services running"
echo "now execute 'source /openrc'"
