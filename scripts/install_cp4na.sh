#!/bin/sh

# Required input parameters
# - KUBECONFIG : Not used directly but required by oc
# - STORAGE_CLASS_NAME
# - DOCKER_REGISTRY_PASS
# - DOCKER_USER_EMAIL
# - STORAGE_CLASS_CONTENT
# - INSTALLER_SENSITIVE_DATA
# - INSTALLER_JOB_CONTENT
# - SCC_ZENUID_CONTENT

# Software requirements:
# - oc
# - kubectl

# Optional input parameters with default values:
NAMESPACE=${default}
DEBUG=${DEBUG:-false}
DOCKER_USERNAME=${DOCKER_USERNAME:-cp}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-cp.icr.io}  # adjust this if needed

JOB_NAME="cloud-installer"
WAITING_TIME=5

echo "Waiting for Ingress domain to be created"
while [[ -z $(kubectl get route -n openshift-ingress router-default -o jsonpath='{.spec.host}' 2>/dev/null) ]]; do
  sleep $WAITING_TIME
done

# echo "Creating namespace ${NAMESPACE}"
echo "creating namespace cp4na"
kubectl create namespace cp4na --dry-run=client -o yaml | kubectl apply -f -

echo "Deploying Catalog Option ${OPERATOR_CATALOG}"
echo "${OPERATOR_CATALOG}" | kubectl apply -f -

echo "Deploying Catalog Option ${COMMON_SERVICES_CATALOG}"
echo "${COMMON_SERVICES_CATALOG}" | kubectl apply -f -

#echo "Deploying Catalog Option ${REDIS_CATALOG}"
#echo "${REDIS_CATALOG}" | kubectl apply -f -


create_secret() {
  secret_name=$1
  namespace=$2
  link=$3

  echo "Creating secret ${secret_name} on ${namespace} from entitlement key"
  kubectl create secret docker-registry ${secret_name} \
    --docker-server=${DOCKER_REGISTRY} \
    --docker-username=${DOCKER_USERNAME} \
    --docker-password=${DOCKER_REGISTRY_PASS} \
    --docker-email=${DOCKER_USER_EMAIL} \
    --namespace=${NAMESPACE}

  # [[ "${link}" != "no-link" ]] && kubectl secrets -n ${namespace} link cpdinstall icp4d-anyuid-docker-pull --for=pull
}

create_secret ibm-entitlement-key ${NAMESPACE}

#echo "Creating Service Account ${SERVICE_ACCOUNT}"
#echo "${SERVICE_ACCOUNT}" | kubectl apply -f -
#sleep 40


echo "Deploying Operator Group ${OPERATOR_GROUP}"
echo "${OPERATOR_GROUP}" | kubectl apply -f -

sleep 10

echo "Deploying Subscription ${SUBSCRIPTION}"
echo "${SUBSCRIPTION}" | kubectl apply -f -


sleep 460

echo "Deploying Orchestration ${ORCHESTRATION}"
echo "${ORCHESTRATION}" | kubectl apply -f -