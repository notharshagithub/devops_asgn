#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v docker >/dev/null 2>&1 || ! command -v minikube >/dev/null 2>&1; then
  echo "Install Docker and Minikube before running this script." >&2
  exit 1
fi
if ! kubectl get nodes >/dev/null 2>&1; then
  echo "Starting Minikube and refreshing kubectl context..."
  sudo systemctl start docker
  minikube start --driver=docker
  minikube update-context
  kubectl config use-context minikube
fi

IMAGE_REF=devsecops-demo:local
echo "== Build and load local image =="
docker build -t "$IMAGE_REF" .
minikube image load "$IMAGE_REF"

echo "== Apply Deployment with local image =="
sed "s|IMAGE_REF_PLACEHOLDER|$IMAGE_REF|g" k8s/deployment.yaml | kubectl apply -f -
kubectl apply -f k8s/service.yaml
kubectl rollout status deployment/devsecops-demo --timeout=180s
kubectl get deployment,pods,services -l app=devsecops-demo -o wide

echo "== Start port-forward on http://127.0.0.1:18086 =="
PF_LOG=/tmp/session17-devsecops-port-forward.log
kubectl port-forward service/devsecops-demo 18086:5000 >"$PF_LOG" 2>&1 &
PF_PID=$!
cleanup() { kill "$PF_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT
for i in $(seq 1 30); do
  if curl -fsS --max-time 2 http://127.0.0.1:18086/healthz >/dev/null 2>&1; then break; fi
  sleep 1
done
curl -i --max-time 10 http://127.0.0.1:18086/
curl -i --max-time 10 http://127.0.0.1:18086/healthz
