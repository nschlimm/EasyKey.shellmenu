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
    selectItem "kubectl get pods" "awk '{print \$1}'" 100 1 "2"
    if [[ $fname == "" ]]; then return 0; fi
    executeCommand "kubectl get pods $fname -o yaml"
}
```

Notice that `selectItem` has following syntax:
```
selectItem <list command> <awk select from line selected> <optional: width if coloring is enabled>  <optional: line id of header> <optional: preselection>
```
<img width="736" alt="image" src="https://github.com/nschlimm/shellmenu/assets/876604/98270286-26cb-4e68-a052-9b403aa41c6f">

The `showPodManifest` example function creates the list above and the `"awk {print \$1}` will select the "NAME" column of the line number entered. If you only hit enter, the preselected line 2 will be chosen which will select `postresql-0` into `$fname` variable.

