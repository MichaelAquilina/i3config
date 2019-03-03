#! /bin/bash

PASSWORD_STORE="$HOME/.password-store"

if [[ -n "$1" ]]; then
    pass -c "$1" > /dev/null
else
    find "$PASSWORD_STORE" -name "*.gpg" \
    -exec realpath --relative-to="$PASSWORD_STORE" {} +\
    | sed "s/\.gpg//"
fi
