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

echo "== Apply mini project resources =="
kubectl apply -f mini-project/content-configmap.yaml
kubectl apply -f mini-project/pvc.yaml
kubectl wait --for=jsonpath='{.status.phase}'=Bound pvc/storage-web-pvc --timeout=180s
kubectl apply -f mini-project/deployment.yaml
kubectl apply -f mini-project/service.yaml
kubectl rollout status deployment/storage-web --timeout=180s

echo "== Pod, PVC and probe status =="
kubectl get pods,pvc,services -o wide
kubectl describe pod -l app=storage-web

echo "== Test page through local port-forward =="
PF_LOG="/tmp/session13-mini-project-port-forward.log"
kubectl port-forward service/storage-web 18081:80 >"$PF_LOG" 2>&1 &
PF_PID=$!
cleanup() { kill "$PF_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT
for i in $(seq 1 30); do
  if curl -fsS --max-time 2 http://127.0.0.1:18081/ >/dev/null 2>&1; then break; fi
  sleep 1
done
curl -fsS --max-time 10 http://127.0.0.1:18081/ | sed -n '1,12p'

echo "== Verify PVC persistence after Pod replacement =="
POD="$(kubectl get pods -l app=storage-web -o jsonpath='{.items[0].metadata.name}')"
kubectl exec "$POD" -- sh -c 'echo "PVC data survived Pod replacement" > /usr/share/nginx/html/persist.txt'
kubectl delete pod "$POD"
kubectl rollout status deployment/storage-web --timeout=180s
NEW_POD="$(kubectl get pods -l app=storage-web -o jsonpath='{.items[0].metadata.name}')"
kubectl wait --for=condition=Ready "pod/$NEW_POD" --timeout=180s
kubectl exec "$NEW_POD" -- cat /usr/share/nginx/html/persist.txt

echo "== Mini project complete =="
kubectl get pods,pvc,services
