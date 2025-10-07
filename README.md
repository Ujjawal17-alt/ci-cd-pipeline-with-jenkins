# Jenkins Pipeline: Build and Push Docker Image

This repository contains a Declarative `Jenkinsfile` that checks out code from GitHub, builds a Docker image, and pushes it to Docker Hub under the `instantprachi` namespace.

Files added:

- `Jenkinsfile` — Declarative Jenkins pipeline.
- `Dockerfile` — Minimal Dockerfile so the pipeline can build an image as a smoke-test.

Quick overview of the pipeline

- Checkout the repo from the supplied `GIT_URL` and `GIT_BRANCH` parameters.
- Build a Docker image named by `IMAGE_NAME` and tagged with `DOCKER_TAG`.
- Authenticate to Docker Hub using a Jenkins credential and push the image.

Jenkins setup steps

1. Ensure your Jenkins agent (or controller) can run Docker commands. The simplest option is a Linux agent with Docker installed. The pipeline uses the Docker Pipeline plugin API.

2. Create a credential in Jenkins for Docker Hub:
   - Kind: Username with password
   - ID: `dockerhub-credentials-id` (or change the ID in the `Jenkinsfile`)
   - Username: your Docker Hub username
   - Password: your Docker Hub password or access token

3. Create a Pipeline job in Jenkins:
   - Pipeline script from SCM (point to your Git repository) OR 'Pipeline script' and paste the `Jenkinsfile` content.
   - If using "Pipeline script from SCM", set the repository URL and branch.

4. Trigger the job and pass parameters if needed (defaults are in the `Jenkinsfile`).

Example parameter values

- `GIT_URL`: `https://github.com/your/repo.git`
- `GIT_BRANCH`: `main`
- `IMAGE_NAME`: `instantprachi/myapp`
- `DOCKER_TAG`: `1.0.${BUILD_NUMBER}`

Local test (PowerShell)

Build the image locally and push (use your own Docker Hub login):

```powershell
# build
docker build -t instantprachi/myapp:local-test .
# login
docker login --username YOUR_DOCKERHUB_USERNAME --password-stdin
# push
docker push instantprachi/myapp:local-test
```

Notes and assumptions

- The pipeline assumes a Jenkins agent with Docker installed and the Docker Pipeline plugin available.
- The pipeline uses a credentials ID `dockerhub-credentials-id`. Change it in the `Jenkinsfile` or in Jenkins if you use a different ID.
- The `Dockerfile` provided is minimal for testing. Replace it with your real application's Dockerfile.

If you want, I can:

- Add tagging with `BUILD_NUMBER` automatically.
- Make the pipeline multi-arch or push multiple tags.
- Add a GitHub webhook example for automatic triggering.

Requirements coverage

- Create a Declarative `Jenkinsfile`: Done.
- Pull code from GitHub: Done (checkout stage using `git`).
- Build Docker image: Done (docker.build).
- Push image to Docker Hub under `instantprachi` namespace: Done (default `IMAGE_NAME` uses `instantprachi/*`).

