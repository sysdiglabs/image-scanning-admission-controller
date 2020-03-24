#!/bin/bash

set -e

if [[ -z "$ANCHORE_CLI_URL" ]]; then
	echo '$ANCHORE_CLI_URL is empty or unset'
	exit 1;
fi;

if [[ -z "$ANCHORE_CLI_USER" ]]; then
	echo '$ANCHORE_CLI_USER is empty or unset'
	exit 1;
fi;

if [[ -z "$ANCHORE_CLI_PASS" ]]; then
	ANCHORE_CLI_PASS=""
else
	ANCHORE_CLI_PASS=${ANCHORE_CLI_PASS}
fi;


sed 's@{{ANCHORE_CLI_URL}}@'"${ANCHORE_CLI_URL}"'@; s@{{ANCHORE_CLI_USER}}@'"${ANCHORE_CLI_USER}"'@; s@{{ANCHORE_CLI_PASS}}@'"${ANCHORE_CLI_PASS}"'@' image-scanning-admission-controller.yaml | kubectl apply -f -

set -ex
sleep 15
kubectl get all -n image-scan-k8s-webhook-system

CA_BUNDLE=$(kubectl -n image-scan-k8s-webhook-system get secret image-scan-k8s-webhook-webhook-server-secret -o jsonpath='{.data.ca-cert\.pem}')

sed 's@{{CA_BUNDLE}}@'"${CA_BUNDLE}"'@' generic-validatingewebhookconfig.yaml | kubectl apply -f -

kubectl get ValidatingWebhookConfiguration
