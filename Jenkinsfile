pipeline {
  agent {
    kubernetes {
      yamlFile 'kaniko-pod.yaml' // Make sure this file exists in your repo root
    }
  }
  environment {
    IMAGE = "justinmseaman/hello-flask:jenkins"
  }
  stages {
    stage('Checkout Code') {
      steps {
        git 'https://github.com/your-user/your-repo.git' // Replace with your actual repo
      }
    }

    stage('Build and Push with Kaniko') {
      steps {
        container('kaniko') {
          sh '''
            cd flask_app
            /kaniko/executor \
              --context `pwd` \
              --dockerfile `pwd`/Dockerfile \
              --destination $IMAGE \
              --skip-tls-verify
          '''
        }
      }
    }
  }
}
