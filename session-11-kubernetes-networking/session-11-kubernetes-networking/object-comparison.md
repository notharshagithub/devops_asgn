# Kubernetes Object Comparison

## Deployment vs ReplicaSet

| Topic | Deployment | ReplicaSet |
|---|---|---|
| Purpose | Declaratively manages application rollouts | Keeps a specified number of matching Pods running |
| Pod management | Manages ReplicaSets, which manage Pods | Creates or deletes Pods to match desired replicas |
| Scaling | Scales through the Deployment | Can scale directly, though Deployment is usually preferred |
| Rolling updates | Supports rollout history, updates, and rollback | Does not independently provide Deployment-style rollout orchestration |
| Relationship | Owns and updates ReplicaSets | Commonly created and managed by a Deployment |

**Summary:** Use Deployments for most stateless applications. The Deployment creates a new ReplicaSet during a template update and gradually shifts replicas between ReplicaSets.

## Deployment vs DaemonSet vs StatefulSet

| Topic | Deployment | DaemonSet | StatefulSet |
|---|---|---|---|
| Use case | Stateless applications and APIs | Node-level agents and monitoring/logging agents | Stateful applications needing stable identity |
| Pod creation | Maintains a chosen replica count | Normally one Pod on each eligible node | Maintains ordered, stable Pod identities |
| Scaling | Change replica count | Add/remove eligible nodes or change scheduling constraints | Change replica count while preserving identity |
| Networking | Commonly exposed through a Service | Can use Services depending on use case | Often paired with a headless Service for stable DNS |
| Storage | Often ephemeral or shared storage | Depends on the agent | Supports stable per-Pod persistent volume claims |
| Example | Web frontend | Node monitoring agent | Database cluster |

## ReplicaSet vs Service

- **ReplicaSet responsibility:** Keeps the desired number of matching Pods running.
- **Service responsibility:** Provides a stable virtual address and routes traffic to matching ready endpoints.
- **Why a Service is needed:** Pod IPs can change when Pods are recreated. A Service provides a stable discovery and access point.
- **Traffic flow:** Client → Service DNS/IP → selected ready Pod endpoint → application container.

A ReplicaSet does not provide network discovery or load balancing by itself. A Service does not create or scale Pods.
