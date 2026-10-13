#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f pods/pod-running.yaml
kubectl apply -f pods/pod-completed.yaml
kubectl apply -f pods/pod-failing.yaml

echo "Waiting briefly for Pod states to settle..."
sleep 10
kubectl get pods
echo
kubectl describe pod lifecycle-running
echo
kubectl describe pod lifecycle-completed
echo
kubectl describe pod lifecycle-failing
