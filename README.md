# zup-flask

Operationalizing a [Flask](https://palletsprojects.com/p/flask/) web app

## How to run it locally?

1. Make sure you have Docker installed in your computer
2. Execute the `run_docker` bash script (it contains all the instructions required)

    bash run_docker.sh

3. Test it by going to:

    http://localhost:8080

  Optionally you can send a query-parameter (`name`)

      http://localhost:8080/?name=Yo

## How to deploy it on the AWS EKS cluster?

I'm using the `RollingUpdate` deployment strategy, to apply a new deployment you can run the below commands in the terminal:

```
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
```

## Capstone Cloud DevOps specifications

1. Set Up Pipeline
2. Build Docker Container
3. Successful Deployment

### Set Up Pipeline

I have created a Jenkins server (with BlueOcean) which is on charge of my Continous Integration and Continous Deployment (CI/CD). Currently I have five stages

1. Lint
2. Build Container
3. Upload image ([to DockerHub](https://hub.docker.com/repository/docker/mckain/my-flask-app))
4. Deploy to AWS EKS (`RollingUpdate`)
5. Removes docker images

### Build Docker Container

The Flask service has been containerized and it's part of the deployment pipeline

### Successful Deployment

I decided to use AWS EKS as my Kubertenes cluster solution, to spin up my EKS cluster I use CloudFormation

**Steps 1**

Create the network resources necessary for the EKS cluster

```
cd infrastructure/
bash create.sh edwin-network-capstone network.yml network_parameters.json
```

**Step 2**

```
cd infrastructure/
bash create.sh edwin-eks-capstone eks_cluster.yml eks_cluster_parameters.json
```