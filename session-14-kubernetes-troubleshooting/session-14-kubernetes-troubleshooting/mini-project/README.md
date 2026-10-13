# Mini Project: Nginx Application with Health Probes

Deploy a ConfigMap-backed web page with a Service plus liveness and readiness probes.

```bash
kubectl apply -f mini-project/content-configmap.yaml
kubectl apply -f mini-project/deployment.yaml
kubectl apply -f mini-project/service.yaml
kubectl rollout status deployment/session14-mini-web
kubectl get pods,services -o wide
kubectl get endpoints session14-mini-service
kubectl describe pods -l app=session14-mini-web
```

Run `./run-mini-project.sh` to perform these steps and verify the page through port-forwarding.

Readiness controls whether a Pod is added to Service endpoints. Liveness detects repeated health failures and can trigger a container restart.
