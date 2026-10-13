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

echo "== Set up a test application =="
kubectl apply -f troubleshooting/deployment.yaml
kubectl rollout status deployment/troubleshooting-web --timeout=180s

echo "== BEFORE FIX: apply intentionally broken Service selector =="
kubectl apply -f troubleshooting/service-broken.yaml
kubectl get service troubleshooting-service
kubectl get pods --show-labels
kubectl get endpoints troubleshooting-service

echo "== Create an in-cluster client =="
kubectl get pod troubleshooting-client >/dev/null 2>&1 || \
  kubectl run troubleshooting-client --image=curlimages/curl:8.10.1 --restart=Never --command -- sleep 3600
kubectl wait --for=condition=Ready pod/troubleshooting-client --timeout=120s

echo "== Test before fix (failure is expected because there are no endpoints) =="
if kubectl exec troubleshooting-client -- curl -fsS --max-time 5 http://troubleshooting-service/; then
  echo "Request unexpectedly succeeded; inspect the Service selector and endpoints."
else
  echo "Expected failure reproduced: Service has no matching endpoints."
fi

echo "== ROOT CAUSE: Service selector app=web-wrong does not match Pod label app=troubleshooting-web =="
kubectl describe service troubleshooting-service

echo "== AFTER FIX: apply the matching selector =="
kubectl apply -f troubleshooting/service-fixed.yaml
kubectl get endpoints troubleshooting-service

echo "== Test after fix (expect Nginx HTML) =="
kubectl exec troubleshooting-client -- curl -fsS --max-time 10 http://troubleshooting-service/ | sed -n '1,12p'
echo "Troubleshooting complete: matching selector restored endpoints and connectivity."
