# shellmenu
Very simple script to generate menu and selections in out favorite shell environment.

- Use single or double column menu
- Call shell functions or immediately execut shell command
- Return to menu once command or function completed
- Log executed commands

# Get started

Easy !
Just look into `example.sh` and update that to write your own menu.
Start with `bash example.sh`.

# Syntax
```
menuInit <menu title>
submenuHead <sub menu title>
menuItem <key> <action name> <shell function|shell comand>
menuItemClm <key> <action name> <shell function|shell command> <key> <action name> <shell function|shell command>
```

# exmaple.sh

```
Super KUBECTL Home

Kubectl Config:
a. Show config                                  b. Switch context
c. Switch namespace                             d. Add cluster
e. Add users (token)                            f. Add context
g. Edit config                                  h. Create namespace

Pods:
j. List pods (ns=current)                       k. List pods (all namespaces)
l. Show pod manifest (desired/observed)         m. Describe pod
n. Get logs                                     o. Log on to pod
p. Log on to DB                                 r. Apply pod manifest
s. Delete pod

Deployments:
v. List deployments (ns=current)                w. List deployments (all namespaces)
x. Show deployment manifest (desired/observed)  y. Describe deployment
z. List replicasets (ns=current)                1. Describe replica set
2. Redeploy                                     3. Deployment history
4. Undo deployment                              5. Deployment status

Services:
6. List services (ns=current)                   7. List services (all namespaces)
8. Show service manifest (desired/observed)     9. Describe service

Other stuff:
I. List images in contexts                      J. Ingress configuration
K. Describe ingress                             L. Edit config map

Press 'q' to quit

Make your choice:
```

# some example functions

The following examples are also taken from my kubectl.sh utility.

A function that collects input and executes a command based on that input.

```
function addUsers() {
   echo "User name (e.g. admin)?"
   read userName
   echo "Token (e.g. bHVNUkxJZU82d0JudWtpdktBbzhDZFVuSDVEYWtiVmJua3RVT3orUkNzDFGH)?"
   read userToken
   executeCommand "kubectl config set-credentials $userName --token $userToken"
}
```

A function where you can select items from a list.

```
function showPodManifest() {
    selectItem "kubectl get pods" "awk '{print \$1}'"
    if [[ $fname == "" ]]; then return 0; fi
    executeCommand "kubectl get pods $fname -o yaml"
}
```

Notice that `selectItem` has following syntax:
```
selectItem <list command> <awk select from line selected>
```




