# EasyKey.shellmenu
Very simple script to generate menu and selections in out favorite shell environment.

- Use single or double column menu
- Call shell functions or immediately execut shell command
- Return to menu once command or function completed
- Log executed commands

# Get started

Easy !
Just look into `example.sh` and update that to write your own menu.
Start with `bash example.sh`.
Or look into EasyKey.git `git.sh` oder EasyKey.kubectl `kubectl.sh`. Two utilities based on EasyKey.shellmenu that in my daily work.

# Syntax
```
menuInit <menu title>
submenuHead <sub menu title>
menuItem <key> <action name> <shell function|shell comand>
menuItemClm <key> <action name> <shell function|shell command> <key> <action name> <shell function|shell command>
```

# exmaple.sh

<img width="600" alt="image" src="https://github.com/nschlimm/shellmenu/assets/876604/ae8a0a16-434a-4c31-8001-01d29996b72c">

# Some example functions

The following example are taken from my kubectl.sh utility for illustration.

```
source ./shellmenu.sh

continuemenu=true
while ${continuemenu:=true}; do
clear
menuInit "Super KUBECTL Home"
submenuHead "Kubectl Config:"
menuItemClm a "Show config" "kubectl config view" b "Switch context" switchContext
menuItemClm c "Switch namespace" switchNamespace d "Add cluster" addCluster 
menuItemClm e "Add users (token)" addUsers f "Add context" addContext 
menuItemClm g "Edit config" "vim ~/.kube/config" h "Create namespace" createNamespace  
echo
submenuHead "Pods:"
menuItemClm j "List pods (ns=current)" "kubectl get pods -o wide" k "List pods (all namespaces)" "kubectl get pods --all-namespaces -o wide"
menuItemClm l "Show pod manifest (desired/observed)" showPodManifest m "Describe pod" describePod
menuItemClm n "Get logs" getPodLogs o "Log on to pod" logOnPod
menuItemClm p "Log on to DB" logOnDb r "Apply pod manifest" applyPodManifest
menuItem s "Delete pod" deletePod
echo
submenuHead "Deployments:"
menuItemClm v "List deployments (ns=current)" "kubectl get deployments -o wide" w "List deployments (all namespaces)" "kubectl get deployments --all-namespaces -o wide"
menuItemClm x "Show deployment manifest (desired/observed)" showDeploymentManifest y "Describe deployment" describeDeployment
menuItemClm z "List replicasets (ns=current)" "kubectl get rs -o wide" 1 "Describe replica set" describeReplicaset
menuItemClm 2 "Redeploy" redeploy 3 "Deployment history" deplHist
menuItemClm 4 "Undo deployment" rollbackDeployment 5 "Deployment status" deployState
echo
submenuHead "Services:"
menuItemClm 6 "List services (ns=current)" "kubectl get services -o wide" 7 "List services (all namespaces)" "kubectl get services --all-namespaces -o wide"
menuItemClm 8 "Show service manifest (desired/observed)" showServiceManifest 9 "Describe service" describeService
echo
submenuHead "Other stuff:"
menuItemClm I "List images in contexts" listImagesInUse J "Ingress configuration" "kubectl get ing -o json | jq -r '.items[].spec.rules[].http.paths[]'"
menuItemClm K "Describe ingress" "kubectl describe ing" "L" "Edit config map" editConfigMap
choice
done
echo "bye, bye, homie!"
```


