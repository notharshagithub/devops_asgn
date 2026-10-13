#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f services/
kubectl rollout status deployment/clusterip-app
kubectl rollout status deployment/nodeport-app
kubectl rollout status deployment/loadbalancer-app
kubectl rollout status deployment/headless-app

echo "== Services, Pods, endpoints =="
kubectl get deployments,pods,services -o wide
kubectl get endpoints

echo "== Create temporary connectivity/DNS test Pod =="
kubectl run curl-test --image=curlimages/curl:8.10.1 --restart=Never --command -- sleep 3600 || true
kubectl wait --for=condition=Ready pod/curl-test --timeout=120s

echo "== ClusterIP connectivity =="
kubectl exec curl-test -- curl -sS --max-time 10 http://clusterip-service

echo "== NodePort details (use minikube service nodeport-service --url in another command) =="
kubectl get service nodeport-service
minikube service nodeport-service --url || true

echo "== LoadBalancer status and in-cluster connectivity =="
kubectl get service loadbalancer-service
kubectl exec curl-test -- curl -sS --max-time 10 http://loadbalancer-service

echo "== ExternalName DNS =="
kubectl get service externalname-service -o yaml
kubectl exec curl-test -- nslookup externalname-service || true

echo "== Headless DNS and endpoints =="
kubectl get service headless-service
kubectl get endpoints headless-service
kubectl exec curl-test -- nslookup headless-service || true

echo "Service demonstration commands finished."
echo "For an external LoadBalancer IP on Minikube, run 'minikube tunnel' in a separate terminal."
