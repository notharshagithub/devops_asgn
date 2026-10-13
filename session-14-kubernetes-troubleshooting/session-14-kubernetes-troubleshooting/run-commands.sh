#!/usr/bin/env bash
set -euo pipefail
if ! kubectl get nodes >/dev/null 2>&1; then
  sudo systemctl start docker
  minikube start --driver=docker
  minikube update-context
  kubectl config use-context minikube
fi
kubectl get nodes
minikube addons enable metrics-server
kubectl apply -f commands/command-demo.yaml
kubectl wait --for=condition=Ready pod/session14-command-demo --timeout=180s
sleep 6
echo '===== kubectl get ====='; kubectl get pods
echo '===== kubectl get -o wide ====='; kubectl get pods -o wide
echo '===== kubectl describe ====='; kubectl describe pod session14-command-demo
echo '===== kubectl logs ====='; kubectl logs session14-command-demo --tail=5
echo '===== kubectl exec ====='; kubectl exec session14-command-demo -- sh -c 'echo hello from inside the container'
echo '===== kubectl events ====='; kubectl events --for pod/session14-command-demo || kubectl get events --sort-by=.lastTimestamp | tail -n 15
echo '===== kubectl explain ====='; kubectl explain pod.spec.containers
echo '===== kubectl top ====='; sleep 20; kubectl top pods || echo 'Metrics not ready yet; retry kubectl top pods shortly.'
