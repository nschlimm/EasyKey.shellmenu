# EasyKey.shellmenu

The time when you forget your favorite commands is over! 💪

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
