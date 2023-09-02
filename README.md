# nms-acm-on-k8s-via-helm


This repository contains the necessary files to install and uninstall the API Connectivity Manager (ACM) Module for the Network Management System (NMS). The ACM Module enables API connectivity management and provides additional functionality to the NMS system.
Contents

The repository contains the following files:

- install.sh: A Bash script to install the ACM Module along with the NMS using Helm.
- uninstall.sh: A Bash script to uninstall the NMS and ACM Module using Helm.
- values.yaml: A YAML file that contains configuration settings for the installation process.

Installation

To install the API Connectivity Manager (ACM) Module along with the NMS, follow these steps:

- Make sure you have Helm installed on your system.
- Dependencies with Instance Manager: Refer to the table to see the module compatibility for each NGINX Management Suite chart https://docs.nginx.com/nginx-management-suite/installation/kubernetes/deploy-api-connectivity-manager/
- Open a terminal and navigate to the repository directory.
- Modify to replace the parameters inside the values.yaml file with the details (e.g., URL and port of your private Docker registry, if applicable) among others. Replace <version> with the tag you noted when loading the Docker image.
- Run the install.sh script:

```
./install.sh
```

This script uses Helm to install the NMS and ACM Module. During the installation process, it sets the nms-hybrid.adminPasswordHash parameter to secure the admin password for the NMS

To enable the ACM Module, the values.yaml file was modified and the below sections were added: 
```
global:
    nmsModules:
        nms-acm:
            enabled: true
nms-acm:
    imagePullSecrets:
    - name: regcred
    acm:
        image:
            repository: <my-docker-registry:port>/nms-acm 
            tag: <version>
```

Uninstallation

To uninstall the NMS and ACM Module, run the following command in the terminal:

```
./uninstall.sh
```

This script uses Helm to uninstall the NMS and ACM Module.

Verify Pods
After running the install.sh script, you can check the status of the pods by running the following command in the terminal:
```
% kubectl get pods -n nms
NAME                            READY   STATUS    RESTARTS   AGE
acm-579c598675-pdmrx            1/1     Running   0          26s
apigw-749f7d457b-zp8hk          1/1     Running   0          26s
clickhouse-8677677b7-4tpxx      1/1     Running   0          27s
core-58684f86cd-77khn           1/1     Running   0          26s
dpm-7dbb645d54-6hdqc            1/1     Running   0          26s
ingestion-b59fc7c86-k9tpt       1/1     Running   0          26s
integrations-7d55f748c7-9fnn6   1/1     Running   0          26s
```

The output will display the list of pods along with their status.

```
% kubectl get service -n nms
NAME           TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
acm            ClusterIP      10.0.173.208   <none>           8037/TCP                     130m
apigw          LoadBalancer   10.0.147.111   20.XXX.XXX.109   443:32720/TCP                130m
clickhouse     ClusterIP      10.0.88.87     <none>           9000/TCP,8123/TCP            130m
core           ClusterIP      10.0.121.125   <none>           8033/TCP,8038/TCP,7891/TCP   130m
dpm            ClusterIP      10.0.12.49     <none>           8034/TCP,8036/TCP,9100/TCP   130m
ingestion      ClusterIP      10.0.153.50    <none>           8035/TCP                     130m
integrations   ClusterIP      10.0.141.80    <none>           8037/TCP                     130m
```

Access https://20.XXX.XXX.109/ from your browser. 

Note: Make sure you have the necessary permissions and configurations in your Kubernetes cluster to successfully install and run the NMS and ACM Module.
