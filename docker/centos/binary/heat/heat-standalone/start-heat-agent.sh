#!/bin/bash

id=`heat stack-list --show-nested | grep DummyNode | cut -f 2 -d ' '`
heat resource-metadata $id dummy > /var/lib/heat-cfntools/cfn-init-data

docker run --name heat-agents --privileged --net=host -v /etc:/host/etc -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/cloud:/var/lib/cloud -v /var/lib/heat-cfntools:/var/lib/heat-cfntools imain/heat-container-agent
