#!/bin/bash

#######################################
# EasyKey.kubectl utility main script #
#######################################

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$script_dir/../shellmenu.sh"
source "$script_dir/ezk-kubectl-functions.sh"

menuInit "EasyKey.kubectl"
  submenuHead "Kubectl Config:" "Test:"
    menuItemClm a "Show config" "kubectl config view" b "Switch context" switchContext
    menuItemClm c "Switch namespace" switchNamespace d "Add cluster" addCluster 
    menuItemClm e "Add users (token)" addUsers f "Add context" addContext 
    menuItemClm g "Edit config" "vim ~/.kube/config" h "Create namespace" createNamespace  
  submenuHead "Pods:"
    menuItemClm j "List pods (ns=current)" "kubectl get pods -o wide" k "List pods (all namespaces)" "kubectl get pods --all-namespaces -o wide"
    menuItemClm l "Show pod manifest (desired/observed)" showPodManifest m "Describe pod" describePod
    menuItemClm n "Get logs" getPodLogs o "Log on to pod" logOnPod
    menuItemClm p "Log on to DB" logOnDb r "Apply pod manifest" applyPodManifest
    menuItem s "Delete pod" deletePod
  submenuHead "Deployments:"
    menuItemClm v "List deployments (ns=current)" "kubectl get deployments -o wide" w "List deployments (all namespaces)" "kubectl get deployments --all-namespaces -o wide"
    menuItemClm x "Show deployment manifest (desired/observed)" showDeploymentManifest y "Describe deployment" describeDeployment
    menuItemClm z "List replicasets (ns=current)" "kubectl get rs -o wide" 1 "Describe replica set" describeReplicaset
    menuItemClm 2 "Redeploy" redeploy 3 "Deployment history" deplHist
    menuItemClm 4 "Undo deployment" rollbackDeployment 5 "Deployment status" deployState
    menuItem E "Edit deployment" editDeployment
  submenuHead "Services:"
    menuItemClm 6 "List services (ns=current)" "kubectl get services -o wide" 7 "List services (all namespaces)" "kubectl get services --all-namespaces -o wide"
    menuItemClm 8 "Show service manifest (desired/observed)" showServiceManifest 9 "Describe service" describeService
  submenuHead "Other stuff:"
    menuItemClm I "List images in contexts" listImagesInUse J "Ingress configuration" "kubectl get ing -o json | jq -r '.items[].spec.rules[].http.paths[]'"
    menuItemClm K "Describe ingress" "kubectl describe ing" "L" "Edit config map" editConfigMap
    menuItem T "Edit Ingress" "kubectl edit ingress"
startMenu "kubeContext"
echo "bye, bye, homie!"

