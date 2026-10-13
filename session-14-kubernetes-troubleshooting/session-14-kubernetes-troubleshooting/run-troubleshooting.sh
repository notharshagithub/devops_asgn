#!/usr/bin/env bash
set -euo pipefail
if ! kubectl get nodes >/dev/null 2>&1; then
  sudo systemctl start docker
  minikube start --driver=docker
  minikube update-context
  kubectl config use-context minikube
fi
kubectl get nodes

echo '===== 1 CrashLoopBackOff: BEFORE ====='
kubectl apply -f troubleshooting/crashloop-broken.yaml; sleep 8
kubectl get pod crashloop-demo -o wide || true
kubectl describe pod crashloop-demo || true
kubectl logs crashloop-demo --previous || kubectl logs crashloop-demo || true
kubectl delete pod crashloop-demo --ignore-not-found --wait=true
echo '===== CrashLoopBackOff: AFTER FIX ====='
kubectl apply -f troubleshooting/crashloop-fixed.yaml
kubectl wait --for=condition=Ready pod/crashloop-demo --timeout=120s
kubectl get pod crashloop-demo

echo '===== 2 ImagePullBackOff: BEFORE ====='
kubectl apply -f troubleshooting/imagepull-broken.yaml; sleep 12
kubectl get pod imagepull-demo -o wide || true
kubectl describe pod imagepull-demo || true
kubectl delete pod imagepull-demo --ignore-not-found --wait=true
echo '===== Image pull: AFTER FIX ====='
kubectl apply -f troubleshooting/imagepull-fixed.yaml
kubectl wait --for=condition=Ready pod/imagepull-demo --timeout=180s
kubectl get pod imagepull-demo

echo '===== 3 Pending: BEFORE ====='
kubectl apply -f troubleshooting/pending-broken.yaml; sleep 3
kubectl get pod pending-demo -o wide || true
kubectl describe pod pending-demo || true
kubectl delete pod pending-demo --ignore-not-found --wait=true
echo '===== Pending: AFTER FIX ====='
kubectl apply -f troubleshooting/pending-fixed.yaml
kubectl wait --for=condition=Ready pod/pending-demo --timeout=180s
kubectl get pod pending-demo -o wide

echo '===== 4 ContainerCreating / missing ConfigMap mount: BEFORE ====='
kubectl apply -f troubleshooting/mount-broken.yaml; sleep 5
kubectl get pod mount-demo -o wide || true
kubectl describe pod mount-demo || true
kubectl delete pod mount-demo --ignore-not-found --wait=true
kubectl create configmap session14-volume-config --from-literal=message='ConfigMap volume mounted successfully' --dry-run=client -o yaml | kubectl apply -f -
echo '===== Mount fix: AFTER ====='
kubectl apply -f troubleshooting/mount-fixed.yaml
kubectl wait --for=condition=Ready pod/mount-demo --timeout=120s
kubectl get pod mount-demo; kubectl logs mount-demo

echo '===== Set up web Pods for Service / DNS / port tests ====='
kubectl apply -f troubleshooting/web-app.yaml
kubectl rollout status deployment/troubleshooting-web --timeout=180s

echo '===== 5 Service connectivity: BEFORE ====='
kubectl apply -f troubleshooting/service-broken.yaml
kubectl get pods --show-labels
kubectl get service troubleshooting-service
kubectl get endpoints troubleshooting-service
echo '===== Service connectivity: AFTER ====='
kubectl apply -f troubleshooting/service-fixed.yaml
kubectl get endpoints troubleshooting-service

kubectl get pod network-client >/dev/null 2>&1 || kubectl run network-client --image=busybox:1.36 --restart=Never --command -- sh -c 'sleep 3600'
kubectl wait --for=condition=Ready pod/network-client --timeout=180s

echo '===== 6 DNS: BEFORE (misspelled name) ====='
kubectl exec network-client -- nslookup troubleshooting-servcie || echo 'Expected failure: misspelled name.'
echo '===== DNS: AFTER (correct FQDN) ====='
kubectl exec network-client -- nslookup troubleshooting-service.default.svc.cluster.local

echo '===== 7 Pod/network port: BEFORE ====='
kubectl apply -f troubleshooting/port-broken.yaml
kubectl get endpoints port-mismatch-service
if kubectl exec network-client -- wget -T 5 -qO- http://port-mismatch-service; then
  echo 'Request unexpectedly succeeded; inspect targetPort.'
else
  echo 'Expected failure: targetPort 8081 does not match Nginx port 80.'
fi
echo '===== Pod/network port: AFTER FIX ====='
kubectl apply -f troubleshooting/port-fixed.yaml
kubectl get endpoints port-mismatch-service
kubectl exec network-client -- wget -T 10 -qO- http://port-mismatch-service | sed -n '1,8p'

echo '===== 8 Configuration: BEFORE ====='
kubectl apply -f troubleshooting/config-broken.yaml; sleep 4
kubectl get pod config-demo -o wide || true
kubectl describe pod config-demo || true
kubectl delete pod config-demo --ignore-not-found --wait=true
kubectl apply -f troubleshooting/configmap.yaml
echo '===== Configuration: AFTER FIX ====='
kubectl apply -f troubleshooting/config-fixed.yaml
kubectl wait --for=condition=Ready pod/config-demo --timeout=120s
kubectl logs config-demo

echo '===== Final verification ====='
kubectl get pods -o wide
kubectl get services,endpoints
kubectl get events --sort-by=.lastTimestamp | tail -n 20
echo 'Troubleshooting demonstrations completed.'
