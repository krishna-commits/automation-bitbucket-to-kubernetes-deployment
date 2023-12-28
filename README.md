# automation-bitbucket-to-kubernetes-deployment

## To know step by step go through the link URL
## https://medium.com/@neupane.krishna33/automatic-bitbucket-pipeline-to-kubernetes-1ffbc96b1cad

##  https://project.neupanekrishna.com.np/automatic-bitbucket-pipeline-to-kubernetes




## Branch Domain Mapping

The `branch_domain_mapping.yml` file defines the mapping between Git branches and corresponding domains for deployment.

- `master`, `dev`, `staging`, `production`: Default .
- `feature_branch_1`, `feature_branch_2`: Custom domains for feature branches.

## Kubernetes Deployment

The `deployment.yaml` file describes the Kubernetes deployment and associated resources.

- This defines a Kubernetes Deployment named {{APP}}-deployment.
- The deployment ensures that there is one replica of the specified pod template.
- The pod template contains a single container named {{APP}} using the Docker image specified by {{IMAGE_URL}}.
- The container exposes port 80.
- This defines a Kubernetes Service named {{APP}}-service.
- The service exposes port 80 and routes traffic to pods with the label app: {{APP}}.
- The service is of type ClusterIP, which means it's only accessible within the cluster.
- This defines a Cert Manager Issuer named letsencrypt-prod.
- It specifies the ACME server for Let's Encrypt, an email address for notifications, and references a secret for storing the private key.
- The solver is configured to use HTTP01 challenge with an Ingress class set to nginx.
- This defines a Kubernetes Ingress named {{APP}}-ingress.
- It specifies TLS configuration for the specified domain ({{DOMAIN}}) with a secret named {{APP}}-tls.
- The rules define how incoming requests are routed to the backend service ({{APP}}-service) based on the specified path.

## Bitbucket Pipelines

The `bitbucket-pipelines.yml` file contains the Bitbucket Pipelines configuration for ECR and Kubernetes deployment.

- This code is a configuration for a Bitbucket Pipelines file (bitbucket-pipelines.yml). Bitbucket Pipelines is a continuous integration and continuous deployment (CI/CD) service provided by Bitbucket. The configuration defines a set of steps to be executed when changes are pushed to branches in a Bitbucket repository. Let's break down the key components of the code:

Global Configuration:
Image Specification:

<!-- image: atlassian/pipelines-awscli -->
Specifies the Docker image to use for the pipeline. In this case, it's atlassian/pipelines-awscli, which includes the AWS CLI.

Pipelines Configuration:
Branches Configuration:
<!-- pipelines:
  branches:
    '*': -->
Defines pipeline configuration for all branches ('*').

Deployment Steps:
<!-- 
- step:
    name: Deploy to ECR and Selection to Branch
    services:
      - docker
    script:
      # ... 
    variables:
      IMAGE_URL: $ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$DOCKER_REPO:$IMAGE_TAG
      DOMAIN: $DOMAIN -->

Configures a pipeline step named "Deploy to ECR and Selection to Branch."
Specifies the Docker service for the step.
Defines a script that performs several actions, including building and pushing a Docker image to Amazon ECR and deploying to Kubernetes.
Sets environment variables (IMAGE_URL and DOMAIN) for use within the step.

Kubernetes Deployment Step:
<!-- - step:
    name: Deploy to Kubernetes
    script:
      # ... 
    variables:
      # ... (variables set for the deployment) -->
Configures a separate pipeline step for deploying to Kubernetes.
Specifies a script that interacts with Kubernetes and deploys the application.
Sets environment variables for the deployment.

Deployment Steps Details:
Docker Image Build and Push:

The script in the first step does the following:
Extracts branch-related information like domain from the branch_domain_mapping.yml file.
Configures AWS credentials based on the branch (production vs. non-production).
Builds and pushes a Docker image to Amazon ECR.
Creates the ECR repository if it doesn't exist.

Kubernetes Deployment:
The script in the second step does the following:
Downloads kubectl and configures it.
Extracts branch-related information again.
Configures AWS credentials.
Checks if the Kubernetes namespace exists and creates it if not.
Updates Kubernetes deployment configuration (deployment.yaml) with relevant details.
Applies the deployment to the Kubernetes cluster, restarting it if necessary.


<!-- Docker Service Configuration:
definitions:
  services:
    docker:
      memory: 7168 -->
Configures the Docker service used in the pipeline with a specified memory limit (7168 MB).


This Bitbucket Pipelines configuration automates the process of building and deploying a Dockerized application to Amazon ECR and Kubernetes based on the branch being pushed. The pipeline is designed to work with both production and non-production branches, adjusting AWS credentials and deployment settings accordingly.

