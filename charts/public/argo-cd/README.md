# INSTRUCTIONS
1. Installation
Add repository
```sh
helm repo add argo https://argoproj.github.io/argo-helm
```
Install chart
```sh
helm upgrade --install argo-cd argo/argo-cd -f values.yaml --version 7.3.4 -n argocd
```
1. 