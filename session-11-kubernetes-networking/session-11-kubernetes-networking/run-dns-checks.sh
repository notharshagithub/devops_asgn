#!/usr/bin/env bash
set -euo pipefail

kubectl get services
kubectl get endpoints
kubectl exec curl-test -- nslookup clusterip-service
kubectl exec curl-test -- nslookup headless-service
kubectl exec curl-test -- nslookup externalname-service
kubectl get pods -n kube-system
kubectl get configmap coredns -n kube-system -o yaml
