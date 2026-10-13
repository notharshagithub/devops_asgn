#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v helm >/dev/null 2>&1; then
  echo "Helm is not installed. On Pop!_OS, try: sudo snap install helm --classic"
  exit 1
fi
if ! kubectl get nodes >/dev/null 2>&1; then
  echo "kubectl cannot reach a cluster; starting Minikube and refreshing context..."
  sudo systemctl start docker
  minikube start --driver=docker
  minikube update-context
  kubectl config use-context minikube
fi
kubectl get nodes

echo "===== helm create ====="
TMP_ROOT="$(mktemp -d)"
helm create "$TMP_ROOT/helm-create-practice"
helm lint "$TMP_ROOT/helm-create-practice"
rm -rf "$TMP_ROOT"

echo "===== helm repo and helm search ====="
if helm repo add bitnami https://charts.bitnami.com/bitnami --force-update; then
  if helm repo update; then
    helm search repo bitnami/nginx --max-col-width 80 | sed -n '1,8p' || true
  else
    echo "Repository update failed (network/repository unavailable); repo commands were attempted."
  fi
else
  echo "Could not add Bitnami repo (network/repository availability); continuing with the local chart."
fi

REL=session15-cli
if helm status "$REL" >/dev/null 2>&1; then
  helm uninstall "$REL"
fi

echo "===== helm install ====="
helm install "$REL" charts/session15-web \
  --set-string page.version=commands-v1 \
  --set-string page.message="Installed with helm install"
DEPLOY="$(kubectl get deployments -l "app.kubernetes.io/instance=$REL" -o jsonpath='{.items[0].metadata.name}')"
kubectl rollout status "deployment/$DEPLOY" --timeout=180s

echo "===== helm list ====="
helm list -a

echo "===== helm status ====="
helm status "$REL"

echo "===== helm get values ====="
helm get values "$REL" --all

echo "===== helm get manifest (first 35 lines) ====="
helm get manifest "$REL" | sed -n '1,35p'

echo "===== helm get notes ====="
helm get notes "$REL"

echo "===== helm upgrade ====="
helm upgrade "$REL" charts/session15-web \
  --set-string page.version=commands-v2 \
  --set-string page.message="Updated with helm upgrade"
kubectl rollout status "deployment/$DEPLOY" --timeout=180s

echo "===== helm history ====="
helm history "$REL"

echo "===== helm rollback ====="
helm rollback "$REL" 1
kubectl rollout status "deployment/$DEPLOY" --timeout=180s
helm status "$REL"

echo "===== verify restored page ====="
POD="$(kubectl get pods -l "app.kubernetes.io/instance=$REL" -o jsonpath='{.items[0].metadata.name}')"
kubectl exec "$POD" -- cat /usr/share/nginx/html/index.html

echo "===== helm uninstall ====="
helm uninstall "$REL"
helm list -a
echo "Command practice complete."
