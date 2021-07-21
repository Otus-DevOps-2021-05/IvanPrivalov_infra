#!/bin/bash

instance_name="reddit-$(date +%d%m%Y-%H%M%S)"

# находим id образа, созданного в packer (по имени)
image_id=$(yc compute image list | grep "reddit-base-1626792584" | awk '{print $2}')

# создаем инстанс
yc compute instance create \
  --name $instance_name \
  --hostname $instance_name \
  --memory=2 \
  --zone ru-central1-a \
  --network-interface subnet-name=otus-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk name=$instance_name,size=10GB,image-id=$image_id \
  --ssh-key ~/.ssh/id_rsa.pub