# Helm Rollback Workflow

Run `./run-rollback.sh` from the assignment root to execute this workflow.

## Install
Revision 1 creates the release with `page.version=v1`.

## Upgrade and verify
Revision 2 sets the page to `v2`; the script waits for the Deployment rollout and prints the HTML served by the Pod.

## Upgrade again and verify
Revision 3 sets the page to `v3`; the script again waits and prints the served page.

## Roll back and verify
`helm rollback session15-rollback 2` restores the values/manifests from revision 2. Helm records the rollback as a new revision (normally revision 4). The live page should once again display `Release version: v2`.

Useful inspection commands:

```bash
helm history session15-rollback
helm status session15-rollback
helm get values session15-rollback --all
helm get manifest session15-rollback
```

Rollback changes the release to an earlier revision; it does not delete the history of later revisions.
