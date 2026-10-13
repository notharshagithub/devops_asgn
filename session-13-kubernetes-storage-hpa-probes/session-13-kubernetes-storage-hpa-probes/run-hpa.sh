#!/usr/bin/env bash
set -euo pipefail
ensure_cluster() {
  if ! kubectl get nodes >/dev/null 2>&1; then
    echo "kubectl cannot reach the cluster; starting Minikube and refreshing context..."
    minikube start --driver=docker
    minikube update-context
    kubectl config use-context minikube
  fi
  kubectl get nodes
}
ensure_cluster

echo "== Enable metrics-server =="
minikube addons enable metrics-server

echo "== Deploy CPU test application and HPA =="
kubectl apply -f hpa/app.yaml
kubectl rollout status deployment/php-apache --timeout=180s
kubectl apply -f hpa/hpa.yml
kubectl apply -f hpa/load-generator.yaml
kubectl wait --for=condition=Ready pod/load-generator --timeout=180s

echo "== Observe HPA metrics and scaling; load generator remains running =="
for i in $(seq 1 10); do
  echo
  echo "---- Sample $i/10 ----"
  kubectl get hpa php-apache
  kubectl get pods -l app=php-apache
  kubectl top pods || true
  sleep 15
done

echo
echo "== HPA detail and events =="
kubectl describe hpa php-apache
echo
kubectl get hpa
kubectl get pods -o wide
echo "Keep load-generator running while capturing the HPA screenshot."
echo "Stop load by running: kubectl delete pod load-generator"
