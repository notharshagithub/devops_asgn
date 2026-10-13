# CoreDNS in Kubernetes

## What is CoreDNS?

CoreDNS is a DNS server that Kubernetes commonly uses for service discovery inside a cluster. It runs as Pods, usually in the `kube-system` namespace.

## Why Kubernetes uses CoreDNS

- Resolves Service names to ClusterIP addresses.
- Resolves headless Service names to endpoint Pod addresses.
- Supports namespace-based discovery.
- Can forward queries for external domains to upstream DNS servers.

## How Service discovery works

1. A workload asks its configured DNS resolver for a Service name.
2. The resolver sends a DNS query to the cluster DNS Service.
3. CoreDNS reads Kubernetes service and endpoint information through its Kubernetes plugin.
4. CoreDNS returns an address or CNAME result.
5. The client connects to the resolved destination.

## DNS naming convention

A standard Service name is:

```text
<service>.<namespace>.svc.<cluster-domain>
```

For example:

```text
clusterip-service.default.svc.cluster.local
```

`cluster.local` is a common default, not a universal requirement.

## CoreDNS configuration

Inspect CoreDNS resources and configuration:

```bash
kubectl get pods -n kube-system
kubectl get service -n kube-system
kubectl get configmap coredns -n kube-system -o yaml
kubectl describe deployment coredns -n kube-system
```

The CoreDNS Corefile is usually stored in the `coredns` ConfigMap. Do not change it for this exercise.

## Troubleshooting DNS

1. Check whether CoreDNS Pods are running:

   ```bash
   kubectl get pods -n kube-system
   ```

2. Check the cluster DNS Service:

   ```bash
   kubectl get service -n kube-system
   ```

3. Verify the target Service and its endpoints:

   ```bash
   kubectl get services
   kubectl get endpoints
   ```

4. Test DNS from a Pod:

   ```bash
   kubectl exec curl-test -- nslookup clusterip-service
   kubectl exec curl-test -- nslookup headless-service
   ```

5. Inspect CoreDNS logs if queries fail:

   ```bash
   kubectl logs -n kube-system deployment/coredns
   ```

6. Inspect the test Pod's DNS configuration:

   ```bash
   kubectl exec curl-test -- cat /etc/resolv.conf
   ```

Possible causes include CoreDNS Pods not running, incorrect Service names or namespaces, missing Service selectors/endpoints, NetworkPolicy restrictions, or an incorrect cluster DNS configuration.

## References

- [Kubernetes DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- [CoreDNS documentation](https://coredns.io/manual/toc/)
