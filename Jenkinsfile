pipeline {
  agent none
  environment {
    REGISTRY = "justinmseaman/hello-flask"

  }
  stages {
    stage('1 & 2. Application Build and Unit Tests') {
      agent{
        kubernetes {
          yamlFile 'pods/python-pod.yaml' 
        }
      }
      steps {
        checkout scm

        container('python'){
          sh '''
            python --version
            cd flask_app
            pwd
            pip install -r requirements.txt
            pip install -r requirements-dev.txt
            cd ..
            ls -la ./flask_app/tests
            pytest flask_app/tests/test_app.py --maxfail=1 --disable-warnings --tb=short
          '''
        }
      } 
    }
    stage('3. SonarQube Scan') {
      agent{
        kubernetes {
          yamlFile 'pods/sonar-pod.yaml' 
        }
      }
      environment {
        SONAR_TOKEN = credentials('sonar-token-id')
      }
      steps {
        withSonarQubeEnv("${SONARQUBE_ENV}") {
          sh 'sonar-scanner -Dsonar.projectKey=task_6 -Dsonar.sources=flask_app -Dsonar.login=$SONAR_TOKEN'
        }
      }
    }

    stage('4. Docker image building and pushing to any Registry') {
      agent{
        kubernetes {
          yamlFile 'pods/kaniko-pod.yaml' // This file defines the kaniko container
        }
      }
      steps {
        //checkout scm

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
    }
    /*
    stage('5. Deploy to K8s with Helm') {
      steps {
        sh """
          helm upgrade --install hello-flask ./helm-chart \
            --set image.repository=${REGISTRY} \
            --set image.tag=${env.GIT_COMMIT.take(7)}
        """
      }
    }
    stage('6. Smoke Test') {
      steps {
        sh 'curl -f http://your-cluster-ip-or-dns/'
      }
    }
  }
  */
  
  }
  post {
    success {
      emailext(
        from: "justin_seaman@outlook.com",
        subject: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body: "The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} completed successfully.\n\nImage: ${env.IMAGE_SHA_TAG}\n\nSee details: ${env.BUILD_URL}",
        to: "justin_seaman@outlook.com, jmseaman0f@gmail.com"
      )
    }
    failure {
      emailext(
        from: "justin_seaman@outlook.com",
        subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body: "The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} has failed.\n\nSee details: ${env.BUILD_URL}",
        to: "justin_seaman@outlook.com, jmseaman0f@gmail.com"
      )
    }
  }
}
