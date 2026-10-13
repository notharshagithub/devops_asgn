# Kubernetes FQDN and Service DNS

## What is an FQDN?

A Fully Qualified Domain Name (FQDN) identifies a host or service within a DNS hierarchy. In Kubernetes, Services receive DNS names that allow workloads to find one another without hard-coding Pod IP addresses.

## Kubernetes Service DNS convention

A typical Service FQDN is:

```text
<service-name>.<namespace>.svc.<cluster-domain>
```

The default cluster domain is commonly `cluster.local`, so an example is:

```text
clusterip-service.default.svc.cluster.local
```

The actual cluster domain can be configured differently.

## Namespace-based DNS

- A Pod in the same namespace can usually use the short Service name, e.g. `clusterip-service`.
- A Pod in another namespace can use `clusterip-service.default`.
- The full name can be used from any namespace: `clusterip-service.default.svc.cluster.local`.

## Pod-to-Service communication

1. A client Pod queries cluster DNS for a Service name.
2. CoreDNS resolves the name to a Service ClusterIP, or to endpoint addresses for a headless Service.
3. Kubernetes Service networking directs traffic to a matching ready Pod endpoint.

## Examples

| Resource | Example DNS name |
|---|---|
| ClusterIP Service | `clusterip-service.default.svc.cluster.local` |
| NodePort Service | `nodeport-service.default.svc.cluster.local` |
| LoadBalancer Service | `loadbalancer-service.default.svc.cluster.local` |
| Headless Service | `headless-service.default.svc.cluster.local` |
| ExternalName Service | `externalname-service.default.svc.cluster.local` (resolves as a CNAME to its external target) |

## Commands to verify

```bash
kubectl get services
kubectl exec curl-test -- nslookup clusterip-service
kubectl exec curl-test -- nslookup headless-service
kubectl exec curl-test -- nslookup externalname-service
```

`curl-test` must exist in the same namespace as these Services for these exact commands. The provided manifests use the `default` namespace.
