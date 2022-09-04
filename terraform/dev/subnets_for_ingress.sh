#!/bin/bash
value=$(<subnets.txt)
sed -i "s/{subnet_ids}/$value/g" ../../kubernetes/deployment/ingress.yaml