wait_for_keypress() {
    stty raw
    REPLY=$(dd bs=1 count=1 2> /dev/null)
    stty -raw
}

wait_for_keypress
echo "$REPLY"
