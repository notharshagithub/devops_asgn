# Kubernetes Volumes

## 1. What is a Kubernetes volume?
A volume provides storage to containers in a Pod. A container's writable filesystem is generally ephemeral; the appropriate volume type determines whether data is shared between containers or can survive container/Pod replacement.

## 2. emptyDir
`emptyDir` is created when a Pod is assigned to a node. Containers in that Pod can share it. Its contents survive a container restart, but are removed when the Pod is removed from the node.

Example: `emptydir-pod.yaml` writes `/data/message.txt` to an `emptyDir` volume.

```bash
kubectl apply -f 01-kubernetes-volumes/emptydir-pod.yaml
kubectl wait --for=condition=Ready pod/emptydir-demo --timeout=120s
kubectl exec emptydir-demo -- cat /data/message.txt
```

Use cases: scratch space, temporary files, and sharing files between containers in the same Pod.

## 3. hostPath
`hostPath` mounts a path from the node's filesystem into a Pod. It can be useful for local development or node agents, but it couples the Pod to a particular node and may have security implications.

Example: `hostpath-pod.yaml` mounts `/tmp/session13-hostpath` from the Minikube node and writes a file there.

```bash
kubectl apply -f 01-kubernetes-volumes/hostpath-pod.yaml
kubectl wait --for=condition=Ready pod/hostpath-demo --timeout=120s
kubectl exec hostpath-demo -- cat /host-data/message.txt
```

With Minikube's Docker driver, the hostPath path is inside the Minikube node/container, not necessarily the laptop's filesystem.

## 4. PersistentVolume (PV)
A PV is a cluster storage resource made available independently from a Pod. It may represent storage from a cloud provider, network storage, a local disk, or another supported backend. A PV's lifecycle is separate from the individual Pod that mounts it.

## 5. PersistentVolumeClaim (PVC)
A PVC is a request for storage by an application. Kubernetes binds a compatible PV to the claim. Pods mount the PVC rather than needing to know the backing storage details.

Example: `pvc.yaml` requests 1 GiB from the `standard` StorageClass, and `pvc-pod.yaml` mounts that claim. The demo writes a file to `/persistent`.

```bash
kubectl apply -f 01-kubernetes-volumes/pvc.yaml
kubectl apply -f 01-kubernetes-volumes/pvc-pod.yaml
kubectl get pvc
kubectl get pv
kubectl exec pvc-demo -- cat /persistent/message.txt
```

## 6. StorageClass
A StorageClass describes how storage can be provisioned, including the provisioner and parameters. Minikube commonly provides a `standard` StorageClass.

```bash
kubectl get storageclass
kubectl describe storageclass standard
```

## 7. Dynamic provisioning
With dynamic provisioning, a PVC requesting a StorageClass can trigger Kubernetes' storage provisioner to create a suitable PV automatically. This avoids manually creating a PV for every claim.

```bash
kubectl get pvc
kubectl get pv
kubectl describe pvc session13-pvc
```

Once the PVC reaches `Bound`, the storage is ready to be mounted by a Pod. Exact behavior depends on the available StorageClass and provisioner.
