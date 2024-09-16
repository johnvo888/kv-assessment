# Build and Test
1. Installation vault
    ```
    $ kubectl create ns vault          
    namespace/vault created

    $ helm repo add hashicorp https://helm.releases.hashicorp.com

    $ helm upgrade --install vault hashicorp/vault -f values.yaml --namespace vault --version 0.28.0

```

# Setup Vault Authentication
```sh
vault auth enable -path kubernetes kubernetes

echo 'path "backend/data/env" {
  capabilities = ["read", "list"]
}' > backend-policy.hcl

vault policy write backend-policy backend-policy.hcl

SA_NAME=$(kubectl get sa vault -o jsonpath="{.secrets[0].name}" -n vault)
SA_JWT_TOKEN=$(kubectl get secret $SA_NAME -o jsonpath="{.data.token}" -n vault | base64 --decode)
SA_CA_CRT=$(kubectl get secret $SA_NAME -o jsonpath="{.data['ca\.crt']}" -n vault | base64 --decode)
K8S_HOST=$(kubectl config view --raw --minify --flatten -o jsonpath="{.clusters[0].cluster.server}")

vault write auth/kubernetes/config \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_host="https://kubernetes.default.svc:443" \
    kubernetes_ca_cert="$SA_CA_CRT" \
    issuer="https://kubernetes.default.svc"

vault write auth/kubernetes/role/backend-env-role \
    bound_service_account_names=backebd-sa \
    bound_service_account_namespaces=production \
    policies=backend-policy \
    ttl=24h

kubectl create clusterrolebinding backend-secret-auth-delegator-binding \
  --clusterrole=system:auth-delegator \
  --serviceaccount=production:backend-sa
```