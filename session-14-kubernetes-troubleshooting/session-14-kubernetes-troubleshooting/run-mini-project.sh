#!/usr/bin/env bash
set -euo pipefail
if ! kubectl get nodes >/dev/null 2>&1; then
  sudo systemctl start docker
  minikube start --driver=docker
  minikube update-context
  kubectl config use-context minikube
fi
kubectl get nodes
kubectl apply -f mini-project/content-configmap.yaml
kubectl apply -f mini-project/deployment.yaml
kubectl apply -f mini-project/service.yaml
kubectl rollout status deployment/session14-mini-web --timeout=180s
echo '===== Pods, Service and endpoints ====='
kubectl get pods,services -o wide
kubectl get endpoints session14-mini-service
echo '===== Readiness and liveness probes ====='
kubectl describe pods -l app=session14-mini-web

echo '===== Local HTTP access through Service port-forward ====='
PF_LOG=/tmp/session14-mini-project-port-forward.log
kubectl port-forward service/session14-mini-service 18083:80 >"$PF_LOG" 2>&1 &
PF_PID=$!
cleanup() { kill "$PF_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT
for i in $(seq 1 30); do
  if curl -fsS --max-time 2 http://127.0.0.1:18083/ >/dev/null 2>&1; then break; fi
  sleep 1
done
curl -i --max-time 10 http://127.0.0.1:18083/ | sed -n '1,18p'
POD="$(kubectl get pods -l app=session14-mini-web -o jsonpath='{.items[0].metadata.name}')"
echo '===== Recent application logs ====='
kubectl logs "$POD" --tail=10
echo 'Mini project complete.'
