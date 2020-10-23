pipeline {
  environment {
    registry = "mckain/my-flask-app"
    registryCredential = 'dockerhub'
  }
  agent any 
  stages {
    stage('Lint') {
      steps {
        sh 'echo "Hello World"'
        sh 'make lint'
      }
    }
    stage('Build container') {
      steps {
        sh 'whoami'
        sh 'pwd'
        sh 'make build'
      }
    }
    stage('Upload to image to DockerHub') {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            sh 'make upload'
          }
        }
      }
    }
    stage('Deploy to AWS EKS') {
      steps {
        withAWS(region:'us-west-2', credentials:'aws-devops-capstone') {
          sh 'aws eks --region us-west-2 update-kubeconfig --name CloudDevOpsCapstone-EKSCluster'
          sh 'kubectl config use-context arn:aws:eks:us-west-2:652029613149:cluster/CloudDevOpsCapstone-EKSCluster'
          sh 'kubectl apply -f k8s/deployment.yml'
          sh 'kubectl apply -f k8s/service.yml'
        }
      }
    }
    stage('Removes docker images') {
      steps {
        sh 'docker system prune -af --volumes'
      }
    }
  }
}