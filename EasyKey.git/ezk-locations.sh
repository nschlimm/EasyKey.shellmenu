wait_for_keypress() {
    stty raw
    REPLY=$(dd bs=1 count=1 2> /dev/null)
    stty -raw
}

echo -n "Make your choice: " && wait_for_keypress
echo "$REPLY"
