kubectl create secret generic grafana-smtp-secret \
  --from-literal=user='your-smtp-user@example.com' \
  --from-literal=password='your-smtp-password' \
  -n jenkins
