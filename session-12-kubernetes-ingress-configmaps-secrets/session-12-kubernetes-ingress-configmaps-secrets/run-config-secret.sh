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

echo "== Create ConfigMap and demo Secret =="
kubectl apply -f configmaps/configmap.yaml
kubectl apply -f secrets/secret.yaml
kubectl apply -f configmaps/pod-configmap.yaml
kubectl apply -f secrets/pod-secret.yaml

kubectl wait --for=condition=Ready pod/configmap-demo --timeout=120s
kubectl wait --for=condition=Ready pod/secret-demo --timeout=120s

echo "== ConfigMap metadata =="
kubectl get configmap app-config
kubectl describe configmap app-config

echo "== ConfigMap values injected as environment variables =="
kubectl exec configmap-demo -- sh -c 'printf "APP_NAME=%s\nAPP_ENV=%s\nLOG_LEVEL=%s\n" "$APP_NAME" "$APP_ENV" "$LOG_LEVEL"'
echo "== Configuration file mounted in the container =="
kubectl exec configmap-demo -- cat /etc/app-config/settings.conf

echo "== Secret metadata (Kubernetes masks values in describe output) =="
kubectl get secret app-secret
kubectl describe secret app-secret

echo "== Demo Secret values injected into the container =="
echo "These are disposable lab credentials, not real secrets."
kubectl exec secret-demo -- sh -c 'printf "APP_USERNAME=%s\nAPP_PASSWORD=%s\n" "$APP_USERNAME" "$APP_PASSWORD"'
