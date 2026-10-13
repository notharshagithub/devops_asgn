# session15-web Helm chart

A small Helm chart for an Nginx page. The page contents and displayed version are configured in `values.yaml`.

- `templates/configmap.yaml`: creates the HTML page from chart values.
- `templates/deployment.yaml`: runs Nginx with readiness/liveness probes and a config checksum to trigger a rollout when the page changes.
- `templates/service.yaml`: provides a stable ClusterIP endpoint.
- `values.yaml`: common configurable values.

Check and render the chart:

```bash
helm lint charts/session15-web
helm template demo charts/session15-web
```

Example installation:

```bash
helm install session15-demo charts/session15-web
```

Example page update:

```bash
helm upgrade session15-demo charts/session15-web --set-string page.version=v2 --set-string page.message="Updated by Helm"
```
