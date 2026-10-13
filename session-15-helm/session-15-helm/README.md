# Session 15: Helm

## 1. Objectives
- Practice essential Helm commands.
- Install, upgrade, verify, and roll back a Helm release.
- Build and use a small Helm chart with templates and `values.yaml`.
- Complete a Helm-managed web application mini project.
- Capture only three screenshots from actual terminal output.

## 2. Requirements and cluster setup

Helm 3 and a working Minikube cluster are required. On Pop!_OS, install Helm if needed:

```bash
sudo snap install helm --classic
```

Then verify the tools and start the cluster:

```bash
helm version
sudo systemctl start docker
minikube start --driver=docker
minikube update-context
kubectl config use-context minikube
kubectl get nodes
```

## 3. Task 1 — Helm commands

Run:

```bash
./run-helm-commands.sh
```

This script demonstrates `helm create`, `helm repo`, `helm search`, `helm install`, `helm list`, `helm status`, `helm get`, `helm upgrade`, `helm history`, `helm rollback`, and `helm uninstall`. Repository commands require network access and are skipped with a note if the chart repository cannot be reached.

### Command reference

| Command | Purpose |
|---|---|
| `helm create NAME` | Scaffolds a new chart with starter templates |
| `helm install RELEASE CHART` | Installs a chart as a named release |
| `helm list` | Lists releases in the current namespace |
| `helm status RELEASE` | Shows release status and resources/notes |
| `helm get values RELEASE --all` | Shows the release's computed values |
| `helm get manifest RELEASE` | Displays the Kubernetes manifests rendered for a release |
| `helm get notes RELEASE` | Displays notes emitted by the chart |
| `helm upgrade RELEASE CHART` | Applies an updated chart or values to an existing release |
| `helm history RELEASE` | Lists revisions for a release |
| `helm rollback RELEASE REVISION` | Rolls back to a prior revision |
| `helm uninstall RELEASE` | Removes a release and its managed resources |
| `helm repo add NAME URL` | Adds a chart repository |
| `helm repo update` | Refreshes repository indexes |
| `helm search repo QUERY` | Searches locally indexed chart repositories |

The provided chart is in `charts/session15-web/`. Its templates create a ConfigMap, Deployment, and Service. `values.yaml` controls replica count, image, Service type, and visible page content.

## 4. Task 2 — Helm rollback workflow

Run:

```bash
./run-rollback.sh
```

The script performs this workflow:
1. Install release revision 1 with page version `v1`.
2. Upgrade to revision 2 with page version `v2`, then verify the live page.
3. Upgrade again to revision 3 with page version `v3`, then verify.
4. Roll back to revision 2.
5. Confirm the resulting revision and verify that the live page shows `v2` again.

The rollback creates a new history revision. It does not erase history. The script leaves the rollback release installed so you can inspect its status and take the screenshot.

Detailed steps are in [`rollback/README.md`](rollback/README.md).

## 5. Task 3 — Mini project

Run:

```bash
./run-mini-project.sh
```

This installs a separate release named `session15-mini` using `mini-project/values-lab.yaml`. The project is a configurable Nginx page managed by a Helm chart. It verifies the deployment rollout, shows the Service, opens a local port-forward, and checks the HTTP response.

Mini-project documentation: [`mini-project/README.md`](mini-project/README.md).

## 6. Screenshots (only 3)

Capture real terminal output and save the images with these exact filenames.

### Screenshot 1 — Helm commands
![Helm command practice](screenshots/01-helm-commands.png)

Capture `helm create`, repository/search output (when available), release install/status/get, upgrade, history, rollback, and uninstall.

### Screenshot 2 — Rollback workflow
![Helm rollback workflow](screenshots/02-helm-rollback.png)

Capture the `v1 → v2 → v3 → rollback to v2` output, plus `helm history` and `helm status`.

### Screenshot 3 — Mini project
![Helm mini project](screenshots/03-mini-project.png)

Capture the rollout status, running Pods, Service, and successful HTTP response.

## 7. Cleanup (optional)

```bash
helm uninstall session15-rollback --ignore-not-found
helm uninstall session15-mini --ignore-not-found
helm uninstall session15-cli --ignore-not-found
```

If your Helm version does not support `--ignore-not-found` for `helm uninstall`, use `helm list -a` first and uninstall only releases that exist.

## 8. References
- [Helm documentation](https://helm.sh/docs/)
- [Helm command reference](https://helm.sh/docs/helm/)
- [Chart templates](https://helm.sh/docs/chart_template_guide/)
- [Helm rollback command](https://helm.sh/docs/helm/helm_rollback/)
