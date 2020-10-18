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
        sh 'make build'
      }
    }
    // stage('Upload to image to DockerHub') {
    //   steps {
    //     Pending
    //   }
    // }
    // stage('Deploy to AWS EKS') {
    //   steps {
    //     Pending
    //   }
    // }
  }
}