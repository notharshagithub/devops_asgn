#!/usr/bin/env bash
set -euo pipefail

echo "== Rolling Update =="
kubectl apply -f deployments/rolling-update.yaml
kubectl rollout status deployment/rolling-demo
kubectl get pods -l app=rolling-demo
kubectl set image deployment/rolling-demo nginx=nginx:1.28
kubectl rollout status deployment/rolling-demo
kubectl get pods -l app=rolling-demo

echo "== Blue-Green =="
kubectl apply -f deployments/blue.yaml
kubectl apply -f deployments/green.yaml
kubectl apply -f deployments/blue-green-service.yaml
kubectl rollout status deployment/blue
kubectl rollout status deployment/green
kubectl get pods --show-labels
echo "Switching Service from Blue to Green"
kubectl patch service blue-green-service -p '{"spec":{"selector":{"app":"demo","version":"green"}}}'
kubectl get endpoints blue-green-service

echo "== Canary =="
kubectl apply -f deployments/canary.yaml
kubectl rollout status deployment/stable
kubectl rollout status deployment/canary
kubectl get pods -l app=canary-demo --show-labels
kubectl get endpoints canary-service

echo "== Recreate =="
kubectl apply -f deployments/recreate.yaml
kubectl rollout status deployment/recreate-demo
kubectl get pods -l app=recreate-demo
kubectl set image deployment/recreate-demo nginx=nginx:1.28
kubectl rollout status deployment/recreate-demo
kubectl get pods -l app=recreate-demo

echo "Deployment demonstrations finished."
