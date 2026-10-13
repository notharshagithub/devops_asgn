# Mini Project: Persistent Web Page with Health Probes

## Goal
Serve a static page from Nginx, initialize it from a ConfigMap, store it on a dynamically provisioned PVC, and use readiness/liveness probes to check the web server.

## Resources
- `content-configmap.yaml`: initial HTML content.
- `pvc.yaml`: requests 1 GiB from the Minikube `standard` StorageClass.
- `deployment.yaml`: initializes the PVC once, then runs Nginx with HTTP probes.
- `service.yaml`: stable in-cluster endpoint.

## Deploy and verify
From the assignment root:

```bash
kubectl apply -f mini-project/content-configmap.yaml
kubectl apply -f mini-project/pvc.yaml
kubectl apply -f mini-project/deployment.yaml
kubectl apply -f mini-project/service.yaml
kubectl rollout status deployment/storage-web
kubectl get pvc,pods,services
kubectl describe pod -l app=storage-web
```

Test persistence by writing a file into the mounted PVC, deleting the Pod, and checking the replacement Pod:

```bash
POD=$(kubectl get pods -l app=storage-web -o jsonpath='{.items[0].metadata.name}')
kubectl exec "$POD" -- sh -c 'echo "PVC data survived Pod replacement" > /usr/share/nginx/html/persist.txt'
kubectl delete pod "$POD"
kubectl rollout status deployment/storage-web
NEW_POD=$(kubectl get pods -l app=storage-web -o jsonpath='{.items[0].metadata.name}')
kubectl exec "$NEW_POD" -- cat /usr/share/nginx/html/persist.txt
```

The file should remain because the PVC is independent of the deleted Pod. The init container creates the original index page only if it is absent.

## Probes
The readiness probe tests whether Nginx can serve `/`; a failed readiness probe removes the Pod from Service endpoints. The liveness probe checks whether the container remains healthy and can trigger a restart after repeated failures.
