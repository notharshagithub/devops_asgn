# Troubleshooting Lab: Service Has No Endpoints

## Problem
The Service exists but cannot route traffic to the intended Pods.

## Commands to investigate
```bash
kubectl get pods --show-labels
kubectl get service troubleshooting-service -o yaml
kubectl get endpoints troubleshooting-service
kubectl describe service troubleshooting-service
```

## Root cause
The Deployment's Pods use the label `app: troubleshooting-web`, but the broken Service uses the selector `app: web-wrong`. No Pods match the selector, so the Service has no endpoints.

## Fix
Apply a Service manifest with the matching selector:

```bash
kubectl apply -f troubleshooting/service-fixed.yaml
kubectl get endpoints troubleshooting-service
kubectl exec troubleshooting-client -- curl -sS http://troubleshooting-service/
```

## Expected result
Before the fix, the endpoints list is empty and the request fails. After the fix, endpoints show the Pod IPs and the request returns the Nginx welcome page.
