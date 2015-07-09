#!/bin/bash

heat stack-create -f deploy-undercloud.yaml -e undercloud-resource.yaml openstack
