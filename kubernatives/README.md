# Kubernetes Fundamentals

## 1. Objective

- Install and configure Minikube.
- Verify Kubernetes cluster status.
- Explore Kubernetes architecture.
- Learn basic Kubernetes objects and commands.
- Perform the Kubernetes Basics tutorial hands-on.

## 2. Environment

| Component | Details |
|---|---|
| Operating System | Pop!_OS Linux |
| Container Runtime | Docker |
| Kubernetes Cluster | Minikube |
| CLI Tool | kubectl |
| Application | Nginx |

## 3. Minikube Installation and Cluster Verification

### Commands Used

```bash
minikube version
kubectl version --client
docker --version

sudo systemctl start docker
minikube start --driver=docker

minikube status
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A
```

### Output Screenshot

![Minikube installation and cluster startup output](<Screenshot_2026-10-13_14-43-25 copy.png>)

## 4. Kubernetes Architecture

Kubernetes is an open-source container orchestration platform used to deploy, manage, scale, and monitor containerized applications.

### Control Plane Components

- **API Server:** Entry point for Kubernetes API requests.
- **etcd:** Stores cluster configuration and state.
- **Scheduler:** Assigns Pods to suitable nodes.
- **Controller Manager:** Ensures the actual cluster state matches the desired state.

### Node Components

- **Kubelet:** Ensures assigned Pods and their containers are running.
- **Container Runtime:** Executes containers, such as containerd.
- **Kube-proxy:** Implements Service networking rules when used by the cluster's networking configuration.

Minikube runs a local Kubernetes cluster. In a typical single-node Minikube setup, the control plane and application workloads can run on the same node.

### Architecture Exploration Commands

```bash
kubectl get nodes
kubectl get namespaces
kubectl get pods -A
kubectl get services -A
kubectl get deployments -A
kubectl describe node minikube
```

### Output Screenshot

![Kubernetes node details and system resource output](<Screenshot_2026-10-13_14-44-41.png>)

![Kubernetes architecture resources and workloads](<Screenshot_2026-10-13_14-44-45.png>)



## 5. Basic Kubernetes Objects

| Object | Description |
|---|---|
| Pod | Smallest deployable unit containing one or more containers. |
| Deployment | Manages replicated Pods and supports scaling and rolling updates. |
| Service | Provides a stable network endpoint to access Pods. |
| Namespace | Organizes Kubernetes resources. |
| Node | Machine on which Kubernetes workloads run. |

## 6. Creating a Deployment

Created an Nginx Deployment to run a containerized web server.

### Commands Used

```bash
kubectl create deployment nginx --image=nginx:1.27
kubectl rollout status deployment/nginx
kubectl get deployments
kubectl get pods -o wide
kubectl describe deployment nginx
```

![Nginx Deployment creation and status output](<Screenshot_2026-10-13_14-47-57.png>)


## 7. Exposing the Application Using a Service

Created a NodePort Service and used port forwarding to access Nginx locally.

### Commands Used

```bash
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get services
kubectl describe service nginx
kubectl port-forward service/nginx 8080:80
```

In another terminal:

```bash
curl -I http://localhost:8080
```

![Nginx Service port-forward verification](<Screenshot_2026-10-13_14-49-09.png>)


## 8. Scaling the Deployment

Scaled the Deployment to three replicas.

### Commands Used

```bash
kubectl scale deployment nginx --replicas=3
kubectl rollout status deployment/nginx
kubectl get deployments
kubectl get pods -o wide
```

### Output Screenshot


## 9. Rolling Update

Updated the Nginx container image from version 1.27 to version 1.28.

### Commands Used

```bash
kubectl set image deployment/nginx nginx=nginx:1.28
kubectl rollout status deployment/nginx
kubectl rollout history deployment/nginx
kubectl get deployment nginx -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

### Output Screenshot



## 10. Cleaning Up Resources

Removed the Deployment and Service created during the practical exercise.

### Commands Used

```bash
kubectl delete service nginx
kubectl delete deployment nginx

kubectl get pods
kubectl get services
kubectl get deployments
```



## 11. Key Learnings

- Installed and configured Minikube using Docker.
- Verified cluster health using kubectl.
- Explored Kubernetes architecture and resource types.
- Created and inspected a Deployment and Pods.
- Exposed an application through a Service.
- Accessed the application using port forwarding.
- Scaled a Deployment to multiple replicas.
- Performed a rolling update.
- Cleaned up Kubernetes resources.

## 12. References

- [Kubernetes Basics Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Minikube Installation Guide](https://minikube.sigs.k8s.io/docs/start/)
- [Kubernetes Architecture](https://kubernetes.io/docs/concepts/architecture/)
- [Kubernetes Resources](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
- [Kubernetes GitHub Repository](https://github.com/kubernetes/kubernetes)
