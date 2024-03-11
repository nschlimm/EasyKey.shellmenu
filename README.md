<p align="center">
    <img src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/2fb79ee4-60ad-4a9d-a224-d3e544662477" width="200px">
</p>

<h1 align="center">Just a simple shell menu :earth_americas: (that simplifies my work)</h1>

The time when you forget your favorite commands is over! 💪

EasyKey.shellmenu is a simple script to generate menus for command execution in your favorite shell environment. ✨  

- Execute your favorite commands with a keystroke
- Use single or double column menu
- Call user-defined shell functions or immediately execute shell command
- Return to menu once command or function completed
- Log executed commands

👌 Increase your productivity and relax !

# Get started

Easy ! 😎 (but it is beneficial to read this manual) 
1. Clone this repository. 
2. Then look into `maven_example.sh`
3. Update that to write your own menu.
4. To start the menu run `bash maven_example.sh` in your terminal (or rename as you wish)
5. Optionally store the menu startup command on your function keys for easy access  

You can also look into [EasyKey.git](https://github.com/nschlimm/EasyKey.shellmenu/tree/main/EasyKey.git) `git.sh` or [EasyKey.kubectl](https://github.com/nschlimm/EasyKey.shellmenu/tree/main/EasyKey.kubectl) `kubectl.sh`. Two utilities based on EasyKey.shellmenu that I use in my daily work.  

# Syntax

Use `menuInit` to initialize a new menu.  
Use `submenuHead` to structure your menu into sub sections.  
Use `menuItem` to define keys in single column menus.  
Use `menuItemClm` to define keys for multi column menus (allows more actions in the menu).  

```
menuInit <menu title>
submenuHead <sub menu title>
menuItem <key> <description> <shell command>
menuItemClm <key> <description> <shell command> <key> <description> <shell command>
```

# Maven demo menu

The following example are taken from `maven_example.sh` for illustration.

```
source ./shellmenu.sh
while ${continuemenu:=true}; do
clear
menuInit "Maven demo menu"
  submenuHead "Life cycle commands:"
     menuItem c "Clean all" "mvn clean:clean"
     menuItem x "Compile" "mvn clean compile" 
     menuItem t "Test" "mvn clean test" 
     menuItem i "Install" "mvn clean install"  
  echo
  submenuHead "Also usefull:"
    menuItem d "Analyze dependencies" "mvn dependency:analyze"
    menuItem u "Clean compile force updates" "mvn clean compile -U -DskipTests" 
    menuItem e "Show effective settings" "mvn help:effective-settings"
    menuItem r "Show local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
    menuItem l "Show global settings file location" showGlobalSettingFile
    echo && importantLog $(pwd)
  choice
done
echo "bye, bye, homie!"
```
Result is the following menu:

<img width="273" alt="image" src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/5cbf1c4c-1027-4e47-b858-9a7fa131e7db">

# Tipp: sourcing shellmenu.sh 

Every menu script you will write needs to source `shellmenu.sh`.   
Here are several options for sourcing `shellmenu.sh` from your menu script:

Option 1: Use absolute paths

```
# Source shellmenu.sh using absolute paths
source "/path/to/shellmenu.sh"
```

Option 2: Relative paths

```
# Source shellmenu.sh using relative paths
source "relative/path/to/shellmenu.sh"
```

Option 3: Set a variable for script directory

```
# Set the variable for the main script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source shellmenu.sh using the variable
source "$SCRIPT_DIR/relative/path/to/shellmenu.sh"
```
