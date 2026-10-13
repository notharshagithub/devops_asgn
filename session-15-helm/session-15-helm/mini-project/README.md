# Mini Project: Helm-managed Configurable Web App

## Goal
Use Helm to package, deploy, configure, upgrade, and verify a small Nginx web page. The chart creates a ConfigMap for page content, a Deployment, a Service, and health probes.

## Run
From the assignment root:

```bash
./run-mini-project.sh
```

This uses `mini-project/values-lab.yaml`, deploys two replicas, checks rollout status, lists the Pods/Service, and tests the site through a local port-forward at `http://127.0.0.1:18085`.

## Useful Helm commands
```bash
helm status session15-mini
helm get values session15-mini --all
helm get manifest session15-mini
helm upgrade session15-mini charts/session15-web -f mini-project/values-lab.yaml --set-string page.version=mini-v2 --set-string page.message="Mini project upgraded"
helm history session15-mini
```

To remove the project after taking screenshots: `helm uninstall session15-mini`.
