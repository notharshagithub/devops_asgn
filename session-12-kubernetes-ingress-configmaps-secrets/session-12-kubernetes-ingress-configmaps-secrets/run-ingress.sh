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

echo "== Enable Minikube NGINX Ingress add-on =="
minikube addons enable ingress

echo "== Deploy app and create Service/Ingress =="
kubectl apply -f ingress/deployment.yaml
kubectl apply -f ingress/service.yaml
kubectl rollout status deployment/ingress-demo --timeout=180s
kubectl apply -f ingress/ingress.yaml

echo "== Wait for the Ingress controller =="
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx --timeout=180s
kubectl get pods -n ingress-nginx
kubectl get ingress
kubectl describe ingress session12-ingress

echo "== Test Ingress routing using a local port-forward and Host header =="
PF_LOG="/tmp/session12-ingress-port-forward.log"
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 18080:80 >"$PF_LOG" 2>&1 &
PF_PID=$!
cleanup() {
  kill "$PF_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for i in $(seq 1 30); do
  if curl -sS --max-time 2 -H 'Host: session12.local' http://127.0.0.1:18080/ >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo '$ curl -i -H "Host: session12.local" http://127.0.0.1:18080/'
curl -i --max-time 10 -H 'Host: session12.local' http://127.0.0.1:18080/ | sed -n '1,18p'
echo "If the response is HTTP 200 and contains the Nginx welcome page, host-based Ingress routing works."
