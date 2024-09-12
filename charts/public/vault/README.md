# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation vault
2.  Checking
# Build and Test
1. Installation vault
    ```
    $ kubectl create ns vault          
    namespace/vault created

    $ helm repo add hashicorp https://helm.releases.hashicorp.com

    $ helm upgrade --install vault hashicorp/vault -f values.yaml --namespace vault --version 0.28.0
    NAME: vault
    LAST DEPLOYED: Wed May 29 18:19:02 2024
    NAMESPACE: vault
    STATUS: deployed
    REVISION: 1
    NOTES:
    Thank you for installing HashiCorp Vault!

    Now that you have deployed Vault, you should look over the docs on using
    Vault with Kubernetes available here:

    https://developer.hashicorp.com/vault/docs


    Your release is named vault. To learn more about the release, try:

    $ helm status vault
    $ helm get manifest vault

2. Checking
```sh
    $ helm ls                                                    
    NAME 	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART       	APP VERSION
    vault	vault    	3       	2024-05-29 18:21:39.713099383 +0700 +07	deployed	vault-0.28.0	1.16.1  
```

# Setup Vault Authentication
```sh
vault auth enable -path kubernetes kubernetes

echo 'path "harmonix-backend/data/env" {
  capabilities = ["read", "list"]
}' > harmonix-backend-policy.hcl

vault policy write harmonix-backend-policy harmonix-backend-policy.hcl

SA_NAME=$(kubectl get sa vault -o jsonpath="{.secrets[0].name}" -n vault)
SA_JWT_TOKEN=$(kubectl get secret $SA_NAME -o jsonpath="{.data.token}" -n vault | base64 --decode)
SA_CA_CRT=$(kubectl get secret $SA_NAME -o jsonpath="{.data['ca\.crt']}" -n vault | base64 --decode)
K8S_HOST=$(kubectl config view --raw --minify --flatten -o jsonpath="{.clusters[0].cluster.server}")

kubectl create clusterrolebinding vault-secret-auth-delegator-binding \
  --clusterrole=system:auth-delegator \
  --serviceaccount=vault:vault

vault write auth/kubernetes/config \
    token_reviewer_jwt="$SA_JWT_TOKEN" \
    kubernetes_host="https://kubernetes.default.svc:443" \
    kubernetes_ca_cert="$SA_CA_CRT" \
    issuer="https://kubernetes.default.svc"

vault write auth/kubernetes/role/harmonix-backend-env-role \
    bound_service_account_names=harmonix-api-sa \
    bound_service_account_namespaces=production \
    policies=harmonix-backend-policy \
    ttl=24h

kubectl create clusterrolebinding harmonix-backend-secret-auth-delegator-binding \
  --clusterrole=system:auth-delegator \
  --serviceaccount=production:harmonix-api-sa
```