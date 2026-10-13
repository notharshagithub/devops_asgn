# Session 20: Monitoring, Observability & GitOps

## 1. Objectives

- Inspect Kubernetes metrics, logs, events, and application health.
- Understand CPU and memory utilization and how alerts are generated.
- Explain the three pillars of observability: metrics, logs, and traces.
- Understand GitOps, declarative configuration, Git as the source of truth, and continuous reconciliation.
- Practice the basic monitoring workflow on Minikube and understand how a GitOps controller deploys Kubernetes resources.

## 2. Monitoring, Observability, and GitOps

**Monitoring** tracks known signals—such as CPU utilization, memory usage, request rates, errors, and application availability—to identify problems and alert operators.

**Observability** uses telemetry to help understand why a system behaves in a particular way, including situations that were not anticipated in advance.

**GitOps** manages infrastructure and application deployment through version-controlled, declarative configuration in Git. A GitOps controller compares the desired state in Git with the actual state in the cluster and reconciles differences.

## 3. Task 1 — Monitoring Demo

### Prerequisites

The examples use Pop!_OS, Docker, Minikube, and `kubectl`.

Start the local cluster and refresh the Kubernetes context:

```bash
sudo systemctl start docker
minikube start --driver=docker
minikube update-context
kubectl config use-context minikube
kubectl get nodes
```

### 3.1 Enable and verify metrics

The Metrics Server provides resource metrics for commands such as `kubectl top`. It is not a complete long-term monitoring or alerting system.

```bash
minikube addons enable metrics-server
kubectl get pods -n kube-system
kubectl top nodes
kubectl top pods -A
```

Metrics may take a short time to become available after enabling the add-on. If `kubectl top` reports that metrics are unavailable, wait briefly and retry.

### 3.2 Deploy a sample application

Create an Nginx Deployment:

```bash
kubectl create deployment monitoring-demo --image=nginx:1.27
kubectl rollout status deployment/monitoring-demo
kubectl get deployments
kubectl get pods -o wide
```

Expose it inside the cluster:

```bash
kubectl expose deployment monitoring-demo --port=80 --target-port=80
kubectl get services
kubectl get endpoints monitoring-demo
```

Test the application through a local port-forward:

```bash
kubectl port-forward service/monitoring-demo 18080:80
```

Keep that command running. In a second terminal:

```bash
curl -I http://127.0.0.1:18080/
```

Stop the port-forward with `Ctrl+C` when finished.

### 3.3 CPU and memory utilization

```bash
kubectl top nodes
kubectl top pods
kubectl top pods --containers
kubectl describe node minikube
```

- **CPU usage** indicates how much CPU time is being consumed.
- **Memory usage** indicates memory currently used by workloads.
- Pod CPU utilization percentages used by an HPA are calculated relative to configured CPU requests; `kubectl top` itself reports observed resource usage.
- Metrics Server is intended for autoscaling and current resource inspection, not durable historical charts.

### 3.4 Logs

```bash
kubectl logs deployment/monitoring-demo
kubectl logs -l app=monitoring-demo --tail=50
kubectl logs POD_NAME --previous
```

Replace `POD_NAME` with the name returned by `kubectl get pods`. The `--previous` option requests logs from the previous container instance, when one exists.

Logs help investigate application errors, startup problems, failed requests, and unexpected container exits.

### 3.5 Events and application health

```bash
kubectl get events --sort-by=.lastTimestamp
kubectl describe deployment monitoring-demo
kubectl describe pod POD_NAME
kubectl get pods
kubectl get endpoints monitoring-demo
kubectl rollout status deployment/monitoring-demo
```

Look for events such as failed image pulls, scheduling failures, failed mounts, probe failures, and container restarts. A Pod showing `Running` does not by itself guarantee that the application is functioning correctly; readiness probes and application-level checks are important.

### 3.6 Alerts

An alert is generated when a measured condition violates a rule—for example, sustained high CPU, a high error rate, a missing target, or repeated application failures.

Kubernetes Events are useful diagnostic records, but they are not a full alerting system by themselves. A common monitoring stack is:

- **Prometheus:** collects and stores time-series metrics.
- **Alertmanager:** groups, routes, silences, and sends alerts raised by Prometheus rules.
- **Grafana:** visualizes metrics and dashboards.
- **Kube-state-metrics:** exposes metrics about Kubernetes object states.
- **Node Exporter:** exposes host-level metrics in supported setups.

Typical alert examples include high CPU usage sustained over several minutes, a workload with unavailable replicas, elevated HTTP error rates, and an application endpoint that is unreachable. Thresholds should be adapted to the application's normal behavior rather than copied blindly.

### 3.7 Cleanup of the monitoring demo

```bash
kubectl delete service monitoring-demo --ignore-not-found
kubectl delete deployment monitoring-demo --ignore-not-found
```

## 4. Task 2 — Observability

Observability is commonly described through three major telemetry pillars: metrics, logs, and traces. They complement one another and are most useful when connected by shared context such as service names, timestamps, and trace IDs.

### 4.1 Metrics

Metrics are numerical measurements collected over time, such as CPU usage, memory consumption, request rate, error rate, and request latency.

**Why they are useful:** Metrics help detect trends, assess capacity, measure service-level indicators, and trigger alerts.

**Common tools:** Prometheus, Grafana, Metrics Server, CloudWatch, and OpenTelemetry metrics pipelines.

**Kubernetes examples:**

```bash
kubectl top nodes
kubectl top pods -A
kubectl get hpa -A
kubectl get deployments -A
```

### 4.2 Logs

Logs are timestamped records produced by applications, containers, and system components. They often contain detailed messages about failures, request handling, and internal events.

**Why they are useful:** Logs provide the detail needed to investigate an individual failure or understand what a component reported at a particular time.

**Common tools:** `kubectl logs`, Loki, Fluent Bit, Elasticsearch/OpenSearch, and cloud logging services.

**Kubernetes examples:**

```bash
kubectl logs deployment/monitoring-demo
kubectl logs POD_NAME --previous
kubectl get events --sort-by=.lastTimestamp
```

### 4.3 Traces

Distributed traces record the path of a request through multiple services. A trace contains spans representing operations, their timing, and parent-child relationships.

**Why they are useful:** Traces help locate latency and errors across service boundaries, especially in microservice architectures.

**Common tools:** OpenTelemetry, Jaeger, Grafana Tempo, and cloud tracing services.

A trace ID can connect a slow request to its related spans and, when propagated through the system, to corresponding logs.

### 4.4 How the pillars work together

For an API response that becomes slow:

1. **Metrics** show that latency or error rate has increased.
2. **Traces** identify which downstream service or operation is taking the most time.
3. **Logs** provide detailed messages for the affected service and request.

Using the pillars together gives better diagnostic context than relying on only one source.

### 4.5 Kubernetes observability

A Kubernetes observability setup may collect:

- Cluster and node CPU, memory, disk, and network metrics.
- Pod and container resource usage.
- Workload status, restarts, and scheduling events.
- Application logs from containers.
- Distributed traces from instrumented applications.
- Alerts for unavailable replicas, resource saturation, high error rates, or failed service checks.

Metrics Server supports current resource metrics, but a production monitoring platform usually needs additional collection, storage, dashboards, and alerting components.

## 5. Task 3 — GitOps

### 5.1 What is GitOps?

GitOps is an operational approach where Git holds the version-controlled desired state for applications and infrastructure. A GitOps controller continuously observes the repository and the Kubernetes cluster, then works to make the actual state match the declared desired state.

### 5.2 Git as the source of truth

Kubernetes YAML manifests, Helm charts, or Kustomize configuration are committed to Git. A change is reviewed through a pull request and merged according to the repository's process.

The merged configuration represents the desired state. The live cluster should converge toward that state through the GitOps controller.

Manual changes made directly to the cluster may be overwritten or reported as drift, depending on the controller and its reconciliation policy.

### 5.3 Declarative configuration

Declarative configuration describes the desired outcome rather than each individual command needed to achieve it.

For example, a Deployment manifest can state that three replicas should run. Kubernetes controllers continuously work toward that replica count even when Pods are deleted or fail.

Declarative resources can be versioned, reviewed, rolled back through Git, and reused across environments with appropriate configuration.

### 5.4 Continuous reconciliation

A GitOps controller regularly compares the desired state stored in Git with the resources in the cluster. When a difference is detected, it can apply changes to restore the desired state, according to its configured policy.

The reconciliation loop helps detect or correct drift and reduces the need for operators to manually apply every change.

### 5.5 GitOps workflow

```text
Developer Changes YAML / Helm Chart
                |
                v
        Commit and Push to Git
                |
                v
          Pull Request Review
                |
                v
            Merge Change
                |
                v
       GitOps Controller Detects Change
                |
                v
       Compare Desired and Live State
                |
                v
          Reconcile Kubernetes
                |
                v
       Verify Application Health
```

### 5.6 Kubernetes and GitOps tools

Common GitOps tools include:

- **Argo CD:** continuously compares Git-defined desired state with Kubernetes resources and provides application status and synchronization controls.
- **Flux CD:** a set of controllers that reconcile Kubernetes resources from declared sources.
- **Helm:** a package manager for Kubernetes applications; it is commonly used with GitOps tools to describe and deploy applications.

Helm is not itself a continuous reconciliation controller. Argo CD and Flux can use Helm charts as input while managing ongoing reconciliation.

### 5.7 Example GitOps repository structure

```text
gitops-repository/
├── apps/
│   └── monitoring-demo/
│       ├── deployment.yaml
│       └── service.yaml
├── environments/
│   ├── development/
│   └── production/
└── README.md
```

This is an example structure; the correct layout depends on the selected GitOps tool and repository design.

### 5.8 GitOps example workflow

1. Keep Kubernetes manifests or Helm values in a Git repository.
2. Make a change, such as increasing a Deployment from two replicas to three.
3. Commit the change and open a pull request.
4. Review and merge the change into the branch watched by the controller.
5. Let Argo CD or Flux detect the change and reconcile the cluster.
6. Inspect synchronization status, rollout status, and application health.
7. Revert the Git change if the release must be rolled back, then verify that the controller reconciles the prior desired state.

### 5.9 Argo CD example commands

Argo CD must first be installed in the cluster and configured for the repository. The following commands are examples for an environment where the Argo CD CLI is installed and the user is authenticated:

```bash
argocd app list
argocd app get APP_NAME
argocd app sync APP_NAME
argocd app history APP_NAME
```

Replace `APP_NAME` with the actual Argo CD application name. Synchronization behavior depends on the application's sync policy and permissions.

## 6. Monitoring vs Observability vs GitOps

| Area | Main question | Primary purpose |
|---|---|---|
| Monitoring | Is the system behaving within expected limits? | Track known health signals and alert on conditions |
| Observability | Why is the system behaving this way? | Investigate system behavior using metrics, logs, and traces |
| GitOps | What should be running, and does the cluster match it? | Version, review, deploy, and reconcile desired state |

These practices complement one another. GitOps manages desired configuration; monitoring and observability help determine whether the resulting system is healthy and explain failures.

## 7. Key Learnings

- Inspected current CPU and memory metrics using Metrics Server.
- Used Kubernetes logs, events, Pod details, and rollout status for basic monitoring.
- Learned how alerts differ from ordinary Kubernetes Events.
- Understood metrics, logs, and traces as the three major observability pillars.
- Learned how GitOps uses declarative configuration, Git as the source of truth, and continuous reconciliation.
- Compared monitoring, observability, and GitOps and how they support reliable Kubernetes operations.

## 8. References

- [Kubernetes resource metrics](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [Kubernetes application troubleshooting](https://kubernetes.io/docs/tasks/debug/)
- [Prometheus documentation](https://prometheus.io/docs/)
- [Grafana documentation](https://grafana.com/docs/)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [Flux documentation](https://fluxcd.io/flux/)
