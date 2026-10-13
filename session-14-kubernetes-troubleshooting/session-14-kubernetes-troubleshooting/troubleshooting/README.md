# Troubleshooting Notes

1. **CrashLoopBackOff** — inspect `kubectl describe pod` and `kubectl logs --previous`. The demo command exits with status 1; replacing it with a long-running command fixes it.
2. **ErrImagePull / ImagePullBackOff** — inspect Pod Events. The image tag is invalid; using `nginx:1.27` fixes it.
3. **Pending** — inspect scheduling Events. The Pod requests a nonexistent node label; removing its `nodeSelector` allows scheduling.
4. **ContainerCreating / FailedMount** — the Pod references a missing ConfigMap volume. Create the ConfigMap and correct the reference. Exact displayed status depends on timing and Kubernetes version.
5. **Service connectivity** — the Service selector `app: wrong-label` matches no Pods. Update it to `app: troubleshooting-web`; Endpoints should appear.
6. **DNS** — a misspelled Service DNS name fails; the correct name `troubleshooting-service.default.svc.cluster.local` resolves.
7. **Pod/network port connectivity** — Service `targetPort: 8081` does not match the Nginx container port 80. Change targetPort to 80.
8. **Configuration** — the Pod references missing ConfigMap `missing-app-settings`. Create `app-settings` and correct `envFrom`.

Useful sequence: `kubectl get pods -o wide`, `kubectl describe pod NAME`, `kubectl logs NAME --previous`, `kubectl get events --sort-by=.lastTimestamp`, `kubectl get services,endpoints`, and `kubectl exec CLIENT -- nslookup SERVICE_FQDN`.
