#!/bin/bash
set -eux
## heat-docker-agents service
#cat <<EOF > /etc/systemd/system/heat-docker-agents.service
#
#[Unit]
#Description=Heat Docker Agent Container
#After=docker.service
#Requires=docker.service
#
#[Service]
#User=root
#Restart=on-failure
#ExecStartPre=-/usr/bin/docker kill heat-agents
#ExecStartPre=-/usr/bin/docker rm heat-agents
#ExecStartPre=/usr/bin/docker pull $agent_image
#ExecStart=/usr/bin/docker run --name heat-agents --privileged --net=host -v /etc:/host/etc -v /usr/bin/atomic:/usr/bin/atomic -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/cloud:/var/lib/cloud -v /var/lib/heat-cfntools:/var/lib/heat-cfntools $agent_image
#ExecStop=/usr/bin/docker stop heat-agents
#
#[Install]
#WantedBy=multi-user.target
#
#EOF
#
## update docker for local insecure registry(optional)
## Note: This is different for different docker versions
## For older docker versions < 1.4.x use commented line
#echo "OPTIONS='--insecure-registry $docker_registry'" >> /etc/sysconfig/docker
##echo "ADD_REGISTRY='--registry-mirror $docker_registry'" >> /etc/sysconfig/docker
#
#/sbin/setenforce 0
#/sbin/modprobe ebtables
#
## Silly workaround for not having proper dns resolution in the baremetal machine
#echo search redhat.com > /etc/resolv.conf
#echo nameserver 8.8.8.8 >> /etc/resolv.conf
#
## Another hack.. we need latest docker..
#/usr/bin/systemctl stop docker.service
#/bin/curl -o /tmp/docker https://test.docker.com/builds/Linux/x86_64/docker-1.6.0-rc5
#/bin/mount -o remount,rw /usr
#/bin/rm /bin/docker
#/bin/cp /tmp/docker /bin/docker
#/bin/chmod 755 /bin/docker
#/bin/sed -i s/ADD_REGISTRY/#ADD_REGISTRY/ /etc/sysconfig/docker
#
## enable and start docker
#/usr/bin/systemctl enable docker.service
#/usr/bin/systemctl restart --no-block docker.service
#
## enable and start heat-docker-agents
#chmod 0640 /etc/systemd/system/heat-docker-agents.service
#/usr/bin/systemctl enable heat-docker-agents.service
#/usr/bin/systemctl start --no-block heat-docker-agents.service
