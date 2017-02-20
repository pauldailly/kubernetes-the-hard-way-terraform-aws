#!/bin/bash

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=terraform/certs/generated/ca.pem \
  --embed-certs=true \
  --server=$1:6443

kubectl config set-credentials admin --token chAng3m3

kubectl config use-context default-context
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config set-context default-context

printf '\n\n'
printf '**************************\n'
printf '*** Component statuses ***\n'
printf '**************************\n'
printf '\n'
kubectl get componentstatuses

printf '\n\n'
printf '**************************\n'
printf '********* Nodes **********\n'
printf '**************************\n'
printf '\n'
kubectl get nodes
