helm repo add cloudflare https://cloudflare.github.io/helm-charts
helm repo update

#Get your token from https://one.dash.cloudflare.com/<UUID>/networks/tunnels/add/cfd_tunnel (Where UUID is tenant specific)
YOUR_TUNNEL_TOKEN="**********************"
NAMESPACE="cf-proxy"

kubectl create namespace $NAMESPACE

helm upgrade --install cloudflared cloudflare/cloudflare-tunnel-remote \
  --namespace cf-proxy \
  --set cloudflare.tunnel_token=$YOUR_TUNNEL_TOKEN

#Now you can set your http://<svc-name>.<namespace>.svc.cluster.local:<port> in the service section of "Add Public Hostname"
