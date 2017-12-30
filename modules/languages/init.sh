# sets up nice tools for various programming languages

# handy php version switcher
function phpswitch {
    if [ "$(which php$1)" != "" ]; then
        alias php="php$1"
        echo "Switched to php$1 successfully"
    else
        echo "Could not find php$1"
    fi
}
