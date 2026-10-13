#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v helm >/dev/null 2>&1; then
  echo "Helm is not installed. On Pop!_OS, try: sudo snap install helm --classic"
  exit 1
fi
if ! kubectl get nodes >/dev/null 2>&1; then
  echo "kubectl cannot reach a cluster; start Minikube and select its context first."
  exit 1
fi

REL=session15-rollback
if helm status "$REL" >/dev/null 2>&1; then
  helm uninstall "$REL"
fi

get_deploy() {
  kubectl get deployments -l "app.kubernetes.io/instance=$REL" -o jsonpath='{.items[0].metadata.name}'
}
verify_page() {
  local pod
  pod="$(kubectl get pods -l "app.kubernetes.io/instance=$REL" -o jsonpath='{.items[0].metadata.name}')"
  kubectl exec "$pod" -- cat /usr/share/nginx/html/index.html
}

echo "========== INSTALL: revision 1 / v1 =========="
helm install "$REL" charts/session15-web \
  --set-string page.version=v1 \
  --set-string page.message="Initial release version one"
kubectl rollout status "deployment/$(get_deploy)" --timeout=180s
helm status "$REL"
verify_page

echo "========== UPGRADE: revision 2 / v2 =========="
helm upgrade "$REL" charts/session15-web \
  --set-string page.version=v2 \
  --set-string page.message="First upgrade version two"
kubectl rollout status "deployment/$(get_deploy)" --timeout=180s
helm history "$REL"
verify_page

echo "========== UPGRADE AGAIN: revision 3 / v3 =========="
helm upgrade "$REL" charts/session15-web \
  --set-string page.version=v3 \
  --set-string page.message="Second upgrade version three"
kubectl rollout status "deployment/$(get_deploy)" --timeout=180s
helm history "$REL"
verify_page

echo "========== ROLLBACK TO REVISION 2 =========="
helm rollback "$REL" 2
kubectl rollout status "deployment/$(get_deploy)" --timeout=180s
helm status "$REL"
helm history "$REL"

echo "========== VERIFY: page should show v2 again =========="
verify_page
echo "Rollback workflow complete. Release $REL remains installed for inspection/screenshots."
