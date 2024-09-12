# Installation Guide

```sh
helm upgrade --install vault-secrets-operator hashicorp/vault-secrets-operator -f values.yaml --version 0.7.1 -n vault-secrets-operator-system
```

## Setup Service Account for Vault Authentication
```sh
NEW_TOKEN=$(kubectl create token kvasmt-api-sa -n sandbox)

echo "
apiVersion: v1
kind: Secret
metadata:
  name: kvasmt-backend-token-secret
  annotations:
    kubernetes.io/service-account.name: "kvasmt-api-sa"
type: kubernetes.io/service-account-token
stringData:
  token: $NEW_TOKEN
" | kubectl apply -f - -n sandbox

kubectl create clusterrolebinding kvasmt-backend-secret-auth-delegator-binding \
  --clusterrole=system:auth-delegator \
  --serviceaccount=sandbox:kvasmt-api-sa
```