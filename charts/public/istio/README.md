# Installation guide

1.	Installation fluxcd
2.	Create the Istio HelmRepository custom resource
3.	Create istio base and istiod
4.	Create Istio gateway
5.  Checking
# Build and Test
1. Installation fluxcd
    ```
    $ flux check --pre
    ► checking prerequisites
    ✔ Kubernetes 1.24.6 >=1.20.6-0
    ✔ prerequisites checks passed

    $ flux install
    ✚ generating manifests
    ✔ manifests build completed
    ► installing components in flux-system namespace
    CustomResourceDefinition/alerts.notification.toolkit.fluxcd.io created
    CustomResourceDefinition/buckets.source.toolkit.fluxcd.io created
    CustomResourceDefinition/gitrepositories.source.toolkit.fluxcd.io created
    CustomResourceDefinition/helmcharts.source.toolkit.fluxcd.io created
    CustomResourceDefinition/helmreleases.helm.toolkit.fluxcd.io created
    CustomResourceDefinition/helmrepositories.source.toolkit.fluxcd.io created
    CustomResourceDefinition/kustomizations.kustomize.toolkit.fluxcd.io created
    CustomResourceDefinition/ocirepositories.source.toolkit.fluxcd.io created
    CustomResourceDefinition/providers.notification.toolkit.fluxcd.io created
    CustomResourceDefinition/receivers.notification.toolkit.fluxcd.io created
    Namespace/flux-system created
    ServiceAccount/flux-system/helm-controller created
    ServiceAccount/flux-system/kustomize-controller created
    ServiceAccount/flux-system/notification-controller created
    ServiceAccount/flux-system/source-controller created
    ClusterRole/crd-controller-flux-system created
    ClusterRoleBinding/cluster-reconciler-flux-system created
    ClusterRoleBinding/crd-controller-flux-system created
    Service/flux-system/notification-controller created
    Service/flux-system/source-controller created
    Service/flux-system/webhook-receiver created
    Deployment/flux-system/helm-controller created
    Deployment/flux-system/kustomize-controller created
    Deployment/flux-system/notification-controller created
    Deployment/flux-system/source-controller created
    NetworkPolicy/flux-system/allow-egress created
    NetworkPolicy/flux-system/allow-scraping created
    NetworkPolicy/flux-system/allow-webhooks created
    ◎ verifying installation
    ✔ helm-controller: deployment ready
    ✔ kustomize-controller: deployment ready
    ✔ notification-controller: deployment ready
    ✔ source-controller: deployment ready
    ✔ install finished

2. Create the Istio HelmRepository custom resource
    ```
    $ kubectl create ns istio-system
    $ kubectl create ns istio-ingress
    namespace/istio-system created
    namespace/istio-ingress created

    $ kubectl apply -f ./helm-istio-repository.yaml
    helmrepository.source.toolkit.fluxcd.io/istio created

3. Create istio base and istiod
    ```
    $ kubectl apply -f ./helm-release-istio-base.yaml
    helmrelease.helm.toolkit.fluxcd.io/istio-base created

    $ kubectl apply -f ./helm-release-istiod.yaml
    helmrelease.helm.toolkit.fluxcd.io/istiod created

4. Create Istio gateway
    ```
    $ kubectl label ns istio-ingress istio-injection=enabled
    namespace/istio-ingress labeled

    $ kubectl apply -f ./helm-release-istio-gateway.yaml
    helmrelease.helm.toolkit.fluxcd.io/istio-ingress created

5. Checking
    ```
    $ helm list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
istio-base      istio-system    1               2024-09-12 03:56:37.235891894 +0000 UTC deployed        base-1.22.2     1.22.2     
istio-ingress   istio-ingress   1               2024-09-12 03:57:02.379609695 +0000 UTC deployed        gateway-1.22.2  1.22.2     
istiod          istio-system    1               2024-09-12 03:56:42.478579738 +0000 UTC deployed        istiod-1.22.2   1.22.2   
    
    $ kubectl get hr -A                       
NAMESPACE       NAME            AGE   READY   STATUS
istio-ingress   istio-ingress   38s   True    Helm install succeeded for release istio-ingress/istio-ingress.v1 with chart gateway@1.22.2
istio-system    istio-base      64s   True    Helm install succeeded for release istio-system/istio-base.v1 with chart base@1.22.2
istio-system    istiod          58s   True    Helm install succeeded for release istio-system/istiod.v1 with chart istiod@1.22.2