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

echo "== emptyDir =="
kubectl apply -f 01-kubernetes-volumes/emptydir-pod.yaml
kubectl wait --for=condition=Ready pod/emptydir-demo --timeout=180s
kubectl exec emptydir-demo -- cat /data/message.txt

echo "== hostPath =="
kubectl apply -f 01-kubernetes-volumes/hostpath-pod.yaml
kubectl wait --for=condition=Ready pod/hostpath-demo --timeout=180s
kubectl exec hostpath-demo -- cat /host-data/message.txt

echo "== PVC, PV and StorageClass / dynamic provisioning =="
kubectl apply -f 01-kubernetes-volumes/pvc.yaml
kubectl wait --for=jsonpath='{.status.phase}'=Bound pvc/session13-pvc --timeout=180s
kubectl apply -f 01-kubernetes-volumes/pvc-pod.yaml
kubectl wait --for=condition=Ready pod/pvc-demo --timeout=180s
kubectl exec pvc-demo -- cat /persistent/message.txt

echo "== Storage resources =="
kubectl get storageclass
kubectl get pvc
kubectl get pv
kubectl get pods -o wide
