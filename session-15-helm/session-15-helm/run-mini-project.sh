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

echo "===== Install/update Helm mini project ====="
helm upgrade --install session15-mini charts/session15-web -f mini-project/values-lab.yaml
DEPLOY="$(kubectl get deployments -l app.kubernetes.io/instance=session15-mini -o jsonpath='{.items[0].metadata.name}')"
SVC="$(kubectl get services -l app.kubernetes.io/instance=session15-mini -o jsonpath='{.items[0].metadata.name}')"
kubectl rollout status "deployment/$DEPLOY" --timeout=180s

echo "===== Release status and resources ====="
helm status session15-mini
kubectl get pods,services -l app.kubernetes.io/instance=session15-mini -o wide
kubectl get endpoints "$SVC"

echo "===== Test the application through a port-forward ====="
PF_LOG=/tmp/session15-mini-project-port-forward.log
kubectl port-forward "service/$SVC" 18085:80 >"$PF_LOG" 2>&1 &
PF_PID=$!
cleanup() { kill "$PF_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

for i in $(seq 1 30); do
  if curl -fsS --max-time 2 http://127.0.0.1:18085/ >/dev/null 2>&1; then break; fi
  sleep 1
done

curl -i --max-time 10 http://127.0.0.1:18085/ | sed -n '1,18p'
echo "===== Helm values and notes ====="
helm get values session15-mini --all
helm get notes session15-mini
echo "Mini project complete."
