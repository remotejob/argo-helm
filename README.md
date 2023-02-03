# K8s-CICD
https://sami-islam.medium.com/stay-safe-with-kubernetes-ci-cd-52d51a7af99c

https://earthly.dev/blog/k8s-gitops-with-fluxcd/

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


flux create hr hello-k8s --chart=hello-k8s --source=GitRepository/argo-helm-config --chart-version=">0.0.0" --namespace argo-helm-config --interval=3m --export > clusters/my-cluster/githelmhr.yaml

kubectl describe helmrelease hello-k8s -n argo-helm-config 

# monitoring
flux create source git flux-monitoring --interval=30m --url=https://github.com/fluxcd/flux2 --branch=main

flux create kustomization kube-prometheus-stack --interval=1h --prune --source=flux-monitoring --path="./manifests/monitoring/kube-prometheus-stack" --health-check-timeout=5m --wait

flux create kustomization monitoring-config \
  --depends-on=kube-prometheus-stack \
  --interval=1h \
  --prune=true \
  --source=flux-monitoring \
  --path="./manifests/monitoring/monitoring-config" \
  --health-check-timeout=1m \
  --wait

kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80

#SLACK

kubectl -n flux-system create secret generic slack-url --from-literal=address=your_slack_webhook

kubectl -n flux-system create secret generic slack-url --from-literal=address=https://hooks.slack.com/services/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

flux create alert-provider slack \
  --type slack \
  --channel general \
  --secret-ref slack-url \
  --export > ./clusters/my-cluster/slack-alert-provider.yaml


flux create alert slack-alert \
  --event-severity info \
  --event-source Kustomization/* \
  --event-source GitRepository/* \
  --provider-ref slack \
  --export > ./clusters/my-cluster/slack-alert.yaml
