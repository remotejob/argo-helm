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