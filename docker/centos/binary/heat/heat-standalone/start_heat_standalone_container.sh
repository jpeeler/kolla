docker run --privileged -it -p 5000:5000 -p 8000:8000  -p 8004:8004 -v /etc/os-collect-config.conf:/etc/os-collect-config.conf -v /var/lib/heat-cfntools:/var/lib/heat-cfntools -v /var/run/docker.sock:/var/run/docker.sock kollaglue/centos-rdo-heat-standalone:latest /bin/bash

