#!/bin/bash
$YOUR_USERNAME="user"
$YOUR_PASSWORD="PAT"
$YOUR_EMAIL="email@example.com"
$YOUR_REGISTRY="https://index.docker.io/v1/"

kubectl create secret docker-registry regcred `
  --docker-username=$YOUR_USERNAME `
  --docker-password=$YOUR_PASSWORD `
  --docker-email=$YOUR_EMAIL `
  --docker-server=$YOUR_REGISTRY`
  -n jenkins