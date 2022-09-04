#!/bin/bash
sed -i "s/{tagVersion}/$1/g" ../kubernetes/deployment/nginx.yaml