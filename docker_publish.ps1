param (
    [Parameter(Mandatory)]
    [string]$dockerUser
)
docker build -t hello-flask .\flask_app
docker login
docker tag hello-flask $dockerUser/hello-flask:local
docker push $dockerUser/hello-flask:local