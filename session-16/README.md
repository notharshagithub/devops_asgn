# Session 16: CI/CD & GitHub Actions

## 1. Objective

The objective of this project is to demonstrate a complete CI/CD pipeline using GitHub Actions. The pipeline automates application building, testing, Docker image creation, and delivery.

## 2. CI vs CD

**Continuous Integration (CI)** is the practice of regularly integrating code changes and automatically validating them through builds and tests.

**Continuous Delivery/Deployment (CD)** automates the process of preparing and releasing validated application changes.

| Continuous Integration (CI) | Continuous Delivery/Deployment (CD) |
|---|---|
| Validates code changes automatically. | Automates application delivery or deployment. |
| Runs builds and tests. | Packages and publishes validated builds. |
| Helps identify errors early. | Makes releases consistent and repeatable. |
| Commonly runs on pushes and pull requests. | Commonly runs after successful CI checks or a release event. |

**Continuous Delivery** prepares changes for release, potentially requiring manual approval. **Continuous Deployment** automatically deploys every change that passes the required checks.

## 3. CI/CD Pipeline

A CI/CD pipeline is an automated sequence of steps that validates, builds, packages, and delivers an application.

### Pipeline workflow

1. A developer pushes code to GitHub or opens a pull request.
2. GitHub Actions triggers the configured workflow.
3. The runner checks out the repository.
4. Dependencies are installed.
5. The application is built and tested.
6. A Docker image is built.
7. The image is published to a container registry.
8. If configured, the application is deployed to the target environment.
9. The workflow results and logs are reviewed.

### Pipeline flow

```text
Developer Push / Pull Request
             |
             v
       GitHub Actions
             |
             v
       Checkout Code
             |
             v
    Install Dependencies
             |
             v
       Build Application
             |
             v
        Run Tests
             |
             v
       CI Validation
             |
             v
      Build Docker Image
             |
             v
   Publish Image to Registry
             |
             v
    Deploy Application
       (if configured)
```

## 4. GitHub Actions

GitHub Actions is an automation platform integrated with GitHub. It allows developers to automate software development tasks such as testing, building, packaging, and deployment.

Workflows are defined using YAML files stored in the `.github/workflows/` directory.

Example structure:

```text
project/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cd.yml
├── Dockerfile
├── README.md
├── src/
└── tests/
```

The actual source-code and workflow filenames may differ depending on the project implementation.

## 5. Important GitHub Actions Concepts

### 5.1 Workflow

A workflow is an automated process defined in a YAML file. It specifies when automation runs and which jobs should execute.

Examples include a CI workflow for testing and a CD workflow for publishing or deploying an application.

### 5.2 Events and Triggers

Events determine when a workflow starts.

Common triggers include:

- `push`: runs when changes are pushed to a repository.
- `pull_request`: runs when a pull request event occurs.
- `workflow_dispatch`: allows a workflow to be started manually.

### 5.3 Jobs

A job is a collection of steps executed on a runner. A workflow can contain multiple jobs, which may execute sequentially or in parallel.

For example, a CI workflow may contain separate jobs for testing and building.

### 5.4 Steps

Steps are individual operations within a job. They can execute shell commands or use reusable GitHub Actions.

Typical steps include checking out code, setting up a runtime, installing dependencies, running tests, and building a Docker image.

### 5.5 Runners

A runner is the machine that executes a workflow job.

GitHub-hosted runners provide managed environments, such as Ubuntu Linux. Self-hosted runners allow organizations to execute jobs on their own infrastructure.

### 5.6 Actions

Actions are reusable components that simplify workflow configuration. For example, the checkout action retrieves repository source code so subsequent steps can work with it.

### 5.7 Secrets

Secrets store sensitive information such as registry tokens, passwords, and deployment credentials.

Secrets can be configured through **GitHub repository → Settings → Secrets and variables → Actions**.

Examples that may be used by the workflow include:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

The exact secrets depend on the configured registry and deployment target.

Sensitive values must never be hard-coded into workflow files, source code, Docker images, or the README. Use tokens with only the permissions required by the pipeline.

### 5.8 Artifacts

Artifacts are files generated during a workflow run that can be uploaded and downloaded later.

Examples include:

- Build output
- Test reports
- Code coverage reports
- Diagnostic files

Artifacts are useful for reviewing pipeline results without rerunning the entire workflow. Container images published to a registry are separate from ordinary workflow artifacts.

## 6. Application Build and Testing

The CI pipeline validates the application before it is released.

Typical steps are:

1. Check out the source code.
2. Configure the required programming language and runtime.
3. Install application dependencies.
4. Build or compile the application.
5. Execute automated tests.
6. Upload relevant build output or test reports, if configured.

If a required build or test step fails, GitHub Actions marks the job as failed. This prevents a failed validation from being treated as a successful CI run.

The commands used for installation, building, and testing depend on the application's language and package manager.

## 7. Dockerfile and Containerization

A Dockerfile defines how an application is packaged into a Docker image.

A typical Dockerfile specifies:

- A base image.
- The working directory.
- Dependency installation.
- Application source files.
- The application port, where appropriate.
- The command used to start the application.

Containerization helps make application execution more consistent across development, testing, and deployment environments.

Example commands for building and running a local image are:

```bash
docker build -t cicd-demo:local .
docker run --rm -p 3000:3000 cicd-demo:local
```

The image name and port should match the actual application.

## 8. Continuous Delivery Pipeline

The CD pipeline automates delivery after the required CI checks succeed.

Typical operations include:

1. Select the source revision that passed CI.
2. Authenticate to the configured container registry.
3. Build and tag a Docker image.
4. Push the image to the registry.
5. Deploy the image to the configured environment, if deployment automation is included.
6. Verify the resulting release or deployment.

The image registry, version-tagging strategy, and deployment target are defined by the workflow configuration.

Publishing an image to a registry demonstrates automated delivery to that registry. A separate deployment step is required to demonstrate deployment to a running environment.

## 9. Pipeline Execution and Verification

The pipeline can be inspected through the GitHub Actions interface.

Steps to verify execution:

1. Push the project to GitHub.
2. Open the repository.
3. Select the **Actions** tab.
4. Open the workflow run triggered by the commit or pull request.
5. Inspect individual jobs and their steps.
6. Verify that build and test steps completed successfully.
7. Check image publication and deployment steps, if configured.
8. Download and inspect workflow artifacts, if any were uploaded.

A successful workflow run confirms that its configured steps completed successfully. If the workflow deploys an application, verify the application separately in the target environment.

## 10. Results and Learnings

This project demonstrates the following concepts:

- The difference between Continuous Integration and Continuous Delivery/Deployment.
- Automated software workflows using GitHub Actions.
- Workflow triggers, jobs, steps, actions, and runners.
- Application building and automated testing.
- Containerization using Docker.
- Secure credential management with GitHub Actions secrets.
- Storage and retrieval of workflow artifacts.
- Docker image publication and application deployment, where configured.
- Monitoring pipeline execution and reviewing logs through GitHub.

## 11. Screenshots

Add the screenshots of your successful pipeline execution below. Keep the image files in the repository and use their relative paths.

### 11.1 CI Pipeline Execution

<!-- Add your CI pipeline screenshot here. -->

### 11.2 CD Pipeline Execution

<!-- Add your CD pipeline screenshot here. -->

### 11.3 Build, Test, and Deployment Results

<!-- Add your build/test or deployment output screenshot here. -->

## 12. References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Understanding GitHub Actions](https://docs.github.com/en/actions/about-github-actions/understanding-github-actions)
- [Workflow Syntax for GitHub Actions](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions)
- [Using Secrets in GitHub Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
- [Docker Documentation](https://docs.docker.com/)
