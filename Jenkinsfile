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
            emailext(
                from: "justin_seaman@outlook.com",
                subject: "✅Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} completed successfully.\n\nImage: ${env.IMAGE_SHA_TAG}\n\nSee details: ${env.BUILD_URL}",
                to: "justin_seaman@outlook.com, jmseaman0f@gmail.com"
            )
        }
        failure {
            emailext(
                from: "justin_seaman@outlook.com",
                subject: "❌Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} has failed.\n\nSee details: ${env.BUILD_URL}",
                to: "justin_seaman@outlook.com, jmseaman0f@gmail.com"
            )
        }
      }
    }
  }
}
