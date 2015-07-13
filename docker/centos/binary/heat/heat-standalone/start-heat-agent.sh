#!/bin/bash
stack_id=`heat stack-list --show-nested | grep DummyNode | cut -f 2 -d ' '`
#stack_id=`heat stack-list | grep openstack | awk '{ print $2 }'`
user_id=`keystone user-list | grep -v cfn | grep heat | awk '{ print $2 }'`
id=`keystone tenant-list | grep admin | awk '{ print $2 }'`
#heat resource-metadata $id dummy > /var/lib/heat-cfntools/cfn-init-data

echo -e \
"[default]" \
"\ncommand=os-refresh-config" \
"\n[ec2]" \
"\nmetadata_url=''" \
"\n[heat]" \
"\nuser_id=$user_id" \
"\npassword=heat" \
"\nauth_url=http://127.0.0.1:5000/v2.0" \
"\nproject_id=$id" \
"\nstack_id=$stack_id" \
"\nresource_name=dummy" \
> /etc/os-collect-config.conf

docker run --name heat-agents --privileged --net=host -v /etc/os-collect-config.conf:/etc/os-collect-config.conf -v /etc:/host/etc -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/cloud:/var/lib/cloud -v /var/lib/heat-cfntools:/var/lib/heat-cfntools imain/heat-container-agent
