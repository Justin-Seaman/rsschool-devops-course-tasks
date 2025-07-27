pipeline {
  agent {
    kubernetes {
      yamlFile 'pods/helm-pod.yaml'
    }
  }    
  stages {
    stage('1. Monitor Pipeline Checkout and confirm helm') {
      steps {
        checkout scm
      } 
    }
    stage('2. Prometheus install') {
      steps {
        container('helm') {
          sh '''
            cd ./monitors/prometheus
            #Using prometheus-commmunity because Bitnami EOL on 8.25.2025
            repo="https://prometheus-community.github.io/helm-charts"
            name="prometheus-community"
            #Update repo sources
            helm repo add $name $repo
            helm repo update
            #Confirm presence of chart
            chart="prometheus-community/prometheus"
            helm search repo $chart
            #Get the values file from repo for modification
            valueFile="prometheus-values.yaml"
            #DEFAULT:wget https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus/values.yaml -O $valueFile
            #Set namespace
            namespace="jenkins"
            #Install/Upgrade
            helm upgrade --install $name $chart --namespace $namespace -f $valueFile
          '''
        }
      }
    }
    stage('3. Grafana Install') {
      steps {
        container('helm') {
          sh '''
            pwd
            ls -ls
            cd ./monitors/grafana
            #Using prometheus-commmunity because Bitnami EOL on 8.25.2025
            repo="https://grafana.github.io/helm-charts"
            name="grafana"
            #Update repo sources
            helm repo add $name $repo
            helm repo update
            #Confirm presence of chart
            chart="grafana/grafana"
            helm search repo $chart
            #Get the values file from repo for modification
            #valueFile="grafana-values.yaml"
            #DEFAULT:wget https://raw.githubusercontent.com/prometheus-community/helm-charts/main/charts/prometheus/values.yaml -O $valueFile
            #Set namespace
            namespace="jenkins"
            #Install/Upgrade
            helm upgrade --install $name $chart --namespace $namespace 
            #-f $valueFile
          '''
        }
      }
    }
    /*
    stage('5. Deploy to K8s with Helm') {
      agent{
        kubernetes {
          yamlFile 'pods/helm-pod.yaml'
        }
      }
      steps {
        container('helm') {
            sh """
              helm upgrade --install hello-flask ./hello-flask \
              --set image.name=${REGISTRY} \
              --set image.tag=${SHORT_SHA}
            """
        }
      }
    }
    stage('6. Smoke Test') {
      agent {
        kubernetes {
          label 'default'
        }
      }
      steps {
        container('jnlp'){
            sh 'curl -f https://hello-flask.justinseaman.com/'
        }
      }
    }
  }
  post {
    success {
      emailext(
        from: "justin_seaman@outlook.com",
        subject: "Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
        body: "The Jenkins job ${env.JOB_NAME} build #${env.BUILD_NUMBER} completed successfully.\n\nImage: ${IMAGE_SHA_TAG}\n\nSee details: ${env.BUILD_URL}",
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
    */
  }
}
