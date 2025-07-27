#Using prometheus commmunity because Bitnami EOL on 8.25.2025
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
namespace="monitoring"
kubectl create namespace $namespace
#Install/Upgrade
helm upgrade --install $name $chart --namespace $namespace -f $valueFile
#Get service
export POD_NAME=$(kubectl get pods --namespace $namespace -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus-community" -o jsonpath="{.items[0].metadata.name}")
#forward on 9090
kubectl --namespace monitoring port-forward $POD_NAME 9090

#NEED TO SSH INTO the HOST AND RUN:
#sudo chown -R 65534:65534 /data/prometheus