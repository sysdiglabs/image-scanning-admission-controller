## Prerequiste
- k8s cluster is ready and kubeconfig(~/.kube/config) is properly configured that can be leveraged by kubectl tool
- Have the following enviroment variables setup: 
  - ANCHORE_CLI_TOKEN
  - ANCHORE_CLI_URL

## Deploy Image Scan Admission Webhook
run `make deploy`

## Clean Image Scan Admission Webhook from Cluster
run `make clean`

## Test
run `make test`

## Limitation
There is a 30 seconds timeout for the webhook validation, it will be limited for the image scanner to return scanning result for a new image. This is because the image scanner need to download the image, unfold the image, and then conduct scanning. There is also a [request](https://github.com/kubernetes/kubernetes/issues/60914) to the upstream to make the webhook timeout configurable. So if there is new image to deploy for the first time, the admission controller will deny the request if no result returns in 30 seconds. However, due to complexity of the deployment workflow, the environment variable `REJECT_IF_TIMEOUT` in the YAML file is used to tune the admission controller timeout behavior. 

