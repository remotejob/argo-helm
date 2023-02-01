# K8s-CICD
https://sami-islam.medium.com/stay-safe-with-kubernetes-ci-cd-52d51a7af99c

k config get-contexts 
k config use-context prod
kubectl config set-context --current --namespace expertjob-online-prod 

kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

Xvl1vA6iJOqbZ7KX

kubectl port-forward svc/argocd-server -n argocd 8080:443


docker build -t hello-k8s:1.0 .

docker tag hello-k8s:1.0 remotejob/hello-k8s:1.0

docker push remotejob/hello-k8s:1.0

kubectl apply -f hello-k8s-application.yaml

kubectl port-forward pod/hello-k8s-7c46df7845-lqk8c 5000:5000 -n prod

kubectl apply -f hello-k8s-application-staging.yaml
kubectl apply -f hello-k8s-application-prod.yaml
kubectl apply -f hello-k8s-application-dev.yaml

kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

export GITHUB_TOKEN=***********

flux check --pre

flux bootstrap github --owner=remotejob --repository=argo-helm --branch=main --path=clusters/my-cluster --personal

flux uninstall --namespace=flux-system

k create ns argo-helm-config

flux create source git argo-helm-config --url=https://github.com/remotejob/argo-helm --tag-semver --interval=3m --username=remotejob --password=$GITHUB_TOKEN --namespace argo-helm-config --export > clusters/my-cluster/gitsource.yaml 
