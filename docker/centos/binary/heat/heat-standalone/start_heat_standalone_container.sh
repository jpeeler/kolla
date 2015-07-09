docker run --privileged -it -p 8000:8000 -v /var/lib/heat-cfntools:/var/lib/heat-cfntools -v /var/run/docker.sock:/var/run/docker.sock kollaglue/centos-rdo-heat-standalone:latest /bin/bash

