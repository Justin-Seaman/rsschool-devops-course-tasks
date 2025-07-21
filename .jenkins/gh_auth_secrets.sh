#!/bin/bash
GITHUB_OAUTH_CLIENT_ID="your-client-id"
GITHUB_OAUTH_CLIENT_SECRET="your-client-secret"

kubectl create secret generic github-oauth-secret --from-literal=client-id=$GITHUB_OAUTH_CLIENT_ID --from-literal=client-secret=$GITHUB_OAUTH_CLIENT_SECRET -n jenkins