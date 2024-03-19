<p align="center">
    <img src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/2fb79ee4-60ad-4a9d-a224-d3e544662477" width="200px">
</p>

<h1 align="center">Just a simple shell menu :hatched_chick:
<br> (that simplified my work) </h1>

The time when you forget your favorite commands is over! :sweat_smile:

EasyKey.shellmenu is a simple script to generate menus for command execution in your favorite shell environment. ✨  

- Execute your favorite commands with a keystroke
- Use single or double column menu
- Call user-defined shell functions or immediately execute shell command
- Return to menu once command or function completed
- Log executed commands

👌 Increase your productivity and relax !

# Get started

Easy ! 😎 
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
Use `startMenu` to start your menu in your shell window.  

```
menuInit <menu title>
submenuHead <sub menu title>
menuItem <key> <description> <shell command>
menuItemClm <key> <description> <shell command> <key> <description> <shell command>
startMenu
```

# Simplest example menu

The simplest menu requires this code:

```
source "./shellmenu.sh"
menuItem c "Clean all" "mvn clean:clean"
menuItem x "Compile" "mvn clean compile" 
menuItem t "Test" "mvn clean test" 
menuItem i "Install" "mvn clean install"  
startMenu
```

<img width="175" alt="image" src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/5b273c27-59f4-4bff-aaa6-b8fbf174bbf9">

# Maven demo menu (single column)

The following example are taken from `maven_example.sh` for illustration.  
The Maven demo has its own heading and sub menu sections, but has only one column.

```
source "/path/to/shellmenu.sh"
menuInit "Maven demo menu"
  submenuHead "Life cycle commands:"
     menuItem c "Clean all" "mvn clean:clean"
     menuItem x "Compile" "mvn clean compile" 
     menuItem t "Test" "mvn clean test" 
     menuItem i "Install" "mvn clean install"  
  submenuHead "Also usefull:"
    menuItem d "Analyze dependencies" "mvn dependency:analyze"
    menuItem u "Clean compile force updates" "mvn clean compile -U -DskipTests" 
    menuItem e "Show effective settings" "mvn help:effective-settings"
    menuItem r "Show local repo location" "mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]'" 
    menuItem l "Show global settings file location" showGlobalSettingFile
startMenu
```
Result is the following menu:

<img width="293" alt="image" src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/8f5ea85c-7ff1-4b87-a99e-eacf77f825fb">

# Example double column menu

The following menu example is taken from the [EasyKey.kubectl](https://github.com/nschlimm/EasyKey.shellmenu/tree/main/EasyKey.git) utility.
The Git menu has many functions and sub sections in two columns to enable maximum amount auf commands in your menu.

<img width="604" alt="image" src="https://github.com/nschlimm/EasyKey.shellmenu/assets/876604/cf923abb-e589-4f1d-a7a9-45d0b1f18404">

# Tipp: sourcing shellmenu.sh 

Every menu script you will write needs to source `shellmenu.sh`.   
Here are several options for sourcing `shellmenu.sh` from your menu script:

Option 1: Use absolute paths

```
# Source shellmenu.sh using absolute paths
source "/path/to/shellmenu.sh"
```

Option 2: Set a variable for script directory

```
# Set the variable for the main script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source shellmenu.sh using the variable
source "$SCRIPT_DIR/relative/path/to/shellmenu.sh"
```
