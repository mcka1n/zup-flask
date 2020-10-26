# zup-flask

Operationalizing a [Flask](https://palletsprojects.com/p/flask/) web app

The infrastructure of this project is being created using the AWS CloudFormation templates located in the [infrastructure/](../master/infrastructure) folder, these templates will create the network resources needed to spin a Kubernetes cluster (EKS)

The deployment to the EKS cluster has been automated via Jenkins

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

----

## Capstone Cloud DevOps specifications

1. Set Up Pipeline
2. Build Docker Container
3. Successful Deployment

### Set Up Pipeline

I have created a Jenkins server (with BlueOcean) which is on charge of my Continous Integration and Continous Deployment (CI/CD). 


To create a Jenkins server:

1. Create an AWS EC2 instance 
2. From the AWS IAM, create a policy, group and a user (following the minimum permissions model)
3. Generate a Key 

```
# Step 1 - Update existing packages
sudo apt-get update

# Step 2 - Install Java
sudo apt install -y default-jdk

# Step 3 - Download Jenkins package. 
# You can go to http://pkg.jenkins.io/debian/ to see the available commands
# First, add a key to your system
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# # Step 4 - Add the following entry in your /etc/apt/sources.list:
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# # Step 5 -Update your local package index
sudo apt-get update

# Step 6 - Install Jenkins
sudo apt-get install -y jenkins

# Step 7 - Start the Jenkins server
sudo systemctl start jenkins

# Step 8 - Enable the service to load during boot
sudo systemctl enable jenkins
sudo systemctl status jenkins

# Step 9 - Install the project's specific dependencies
## Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
### Allowing the user jenkins to use the docker command
sudo usermod -aG docker jenkins
id -nG

## hadolint
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_6
sudo chmod +x /bin/hadolint

## AWS CLI
sudo apt  install awscli

## Kubernetes
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

```

Once you are done with the machine setup, set the initial password:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Finally, about the Jenkins pipeline, currently I have five stages:

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
