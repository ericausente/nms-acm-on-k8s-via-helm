#!/bin/bash

helm install -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -1 'YourPassword123#') -f values.yaml  nms nginx-stable/nms --create-namespace --wait
