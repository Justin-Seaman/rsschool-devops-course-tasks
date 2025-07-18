# A quick backup script to preserve jenkins state outside of JCasC
minikube ssh -- "sudo tar -czvf /data/backup/jenkins-backup.tar.gz -C /data/jenkins-volume"
minikube cp minikube:/data/backup/jenkins-backup.tar.gz .\.jenkins\backup\