#!/bin/bash
value=$(<./terraform/dev/subnets.txt)
sed -i "s/{subnet_ids}/$value/g" ./kubernetes/deployment/ingress.yaml