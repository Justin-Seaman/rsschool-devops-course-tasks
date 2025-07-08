#Fresh start
# Task 5: Simple Application Deployment with Helm

![task_5 schema](./.visual_assets/task_4-6.png)


## Application Setup and Deployment

### Dockerfile: Build and Deploy

+ The Dockerfile stored in the flask app directory directs Docker how to build the container including
    1. Pull Python3.9 from docker hub ([link](https://hub.docker.com/_/python))
    2. Copy the [flask_app](flask_app) directory to container
    3. Run pip install on [requirments.txt](flask_app\requirements.txt)
    4. Set environment variables for entrypoint script (run flask service on 0.0.0.0/8080)
    5. Launch flaks service with execution of entrypoint script
+ [build-and-run.ps1](build-and-run.ps1) for local testing
+ [docker_publish.ps1](docker_publish.ps1) for local publishing to Docker Hub
+ [Docker Publish GitHub Action](.github\workflows\docker_publish.yml) to push latest and sha1 hash of Pushes to Branch = Task_5
    + Depends on GH-Secrets for `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` (https://docs.docker.com/security/for-developers/access-tokens/)
+ https://hub.docker.com/r/justinmseaman/hello-flask

### Helm Application

+ Run `helm create hello-flask` to create framework+ boilerplate
+ Configure the following core files:
    + [Chart.yml](Chart.yml) -> Application metadata like name/version
    + [Values.yml](Values.yml) -> Variables which can be used across helm repo by reference. Can be overwritten easily with -f
    + [/templates/deployment.yml](/templates/deployment.yml) -> Set core containerd values like image name:tag, replica count, label selector, etc.
    + [/templates/service.yml](/templates/service.yml) -> Set networking services between container and cluster
    + [/templates/NOTES.txt](/templates/NOTES.txt) -> Output on install for user guidance
    + [/templates/configmap.yaml](/templates/configmap.yaml) -> Creation of data fields and env variables for passing to container

### Network Access

The default configuration is to use NodePort configuraiton to get access to HTTP via tcp/30000. You can modify this by modifying the .Values.service.nodePort integer to some ephemeral port. You can modify the docker image's port and ip by setting different env variables on the docker container with configmap/deployment.

---
## Objective

In this task, you will create a Docker image and Helm chart for a simple application and deploy it on your Kubernetes (K8s) cluster.

## Steps

1. **Create Helm Chart**

   - Create a Helm chart for your [Application](https://github.com/rolling-scopes-school/tasks/tree/master/devops/flask_app/README.md).
     
   
     + Docker Container Build and deploy: [Dockerfile](./flask_app/Dockerfile)
     + Docker Container Artifact [Link](https://github.com/Justin-Seaman/rsschool-devops-course-tasks/actions/runs/16136139585/artifacts/3483377041)
     + Helm chart [directory](./hello-flask/)


2. **Deploy the Application**

   - Deploy the application using the Helm chart.
   
        ![helm-deploy](.visual_assets\helm-deploy.png)
   
   - Ensure the application is accessible from the web browser.

        ![node-ip](.visual_assets\node-ip.png)

        ![hello-flask](.visual_assets\hello-flask.png)

3. **Store Artifacts in Git**

   - Store the application and Helm chart in your git repository.

        + [Application](flask_app)
        + [Helm chart](hello-flask)

4. **Additional Tasks💫**
   - Document the application setup and deployment process in a README file. ✅

## Submission

- Create a `task_5` branch from `main` in your repository.
- Provide a PR with the application and Helm chart in your repository.
- Provide a screenshot from your browser with working application.
- Provide a README file documenting the application setup and deployment process.

## Evaluation Criteria (100 points for covering all criteria)

1. **Helm Chart Creation (40 points)**

   - A Helm chart for the application is created.

2. **Application Deployment (50 points)**

   - The application is deployed using the Helm chart.
   - The application is accessible from the web browser.

3. **Additional Tasks (10 points)💫**
   - **Documentation (10 points)**
     - The application setup and deployment processes are documented in a README file.

## References

- [Create your HELM chart](https://helm.sh/docs/helm/helm_create/)