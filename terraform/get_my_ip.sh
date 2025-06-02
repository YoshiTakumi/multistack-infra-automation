#!/bin/bash
IP=$(curl -s https://checkip.amazonaws.com)
echo "my_ip = \"${IP}/32\"" > my_ip.auto.tfvars
