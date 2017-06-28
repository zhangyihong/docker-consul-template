#!/bin/sh

echo "Generating kubeconfig..."
export KUBECONFIG="$(pwd)/kubeconfig"
KUBE_CLUSTER_OPTIONS=--certificate-authority="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"

 
kubectl config set-cluster local-deploy --server="$KUBE_URL" \
  $KUBE_CLUSTER_OPTIONS

kubectl config set-credentials local-deploy --token=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`

kubectl config set-context local-deploy \
  --cluster=local-deploy --user=local-deploy \
  --namespace="$KUBE_NAMESPACE"

kubectl config use-context local-deploy

KILL_PID=`kubectl exec $HOSTNAME -c $KUBE_KILL_NAME -- ps ax |grep java |awk -F" " '{print $1}'`

echo "KILL ${KUBE_KILL_NAME} container KILL_PID: ${KILL_PID}"

kubectl exec $HOSTNAME -c $KUBE_KILL_NAME -- kill -9 $KILL_PID

