pipeline {
  agent none
  
  stages {
    stage('STEP 4: Docker image building and pushing to any Registry') {
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
          emailext(
            subject: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "The build succeeded!\nImage: ${env.IMAGE_SHA_TAG}",
            to: 'justin_seaman@outlook.com'
          )
        }
        failure {
          echo "❌ Build failed"
          emailext(
            subject: "❌ FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "The build failed. Check console output:\n${env.BUILD_URL}",
            to: 'you@example.com'
          )
        }
      }
    }
  }
}
