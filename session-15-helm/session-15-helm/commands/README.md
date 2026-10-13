# Helm Command Practice

Run `./run-helm-commands.sh` from the assignment root. It demonstrates:
- `helm create` — generate a starter chart in a temporary directory and lint it.
- `helm repo add`, `helm repo update`, `helm search repo` — work with a public chart repository (network required).
- `helm install`, `helm list`, `helm status`.
- `helm get values`, `helm get manifest`, `helm get notes`.
- `helm upgrade`, `helm history`, `helm rollback`, and `helm uninstall`.

The script removes its practice release at the end. The separate rollback exercise leaves its release installed for inspection.
