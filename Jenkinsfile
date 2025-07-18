pipeline {
  agent none
  
  stages {
    stage('Build and Push with Kaniko') {
      agent{
        kubernetes {
          yamlFile 'kaniko-pod.yaml' // This file defines the kaniko container
        }
      }
      environment {
        REGISTRY = "justinmseaman/hello-flask"
      }
      steps {
        checkout scm

        script {
          def sha = env.GIT_COMMIT ?: 'manual'
          def shortSha = sha.take(7)
          def imageTagSha = "${env.REGISTRY}:${shortSha}"
          def imageTagLatest = "${env.REGISTRY}:latest"
          container('kaniko') {
          sh """
            cd flask_app 
            /kaniko/executor \
            --context `pwd` \
            --dockerfile `pwd`/Dockerfile \
            --destination ${imageTagSha} \
            --destination ${imageTagLatest} \
            --skip-tls-verify
            """
          }
          env.IMAGE_SHA_TAG = imageTagSha
        }
      }
      post {
        success {
          echo "✅ Docker image pushed: ${env.IMAGE_SHA_TAG}"
        }
        failure {
          echo "❌ Build failed"
        }
      }
    }
  }
}
