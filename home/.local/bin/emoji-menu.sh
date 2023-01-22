#!/bin/bash
# Originally from https://github.com/galizur/.dotfiles

set -e

DIR="$HOME/.cache"
FILE="$DIR/emojis.txt"
VER='15.0'
URL="https://www.unicode.org/Public/emoji/${VER}/emoji-test.txt"

get_emojis() {
    if [ ! -r $FILE ]; then
        if [ ! -d $DIR ]; then
            mkdir $DIR;
        fi
        curl $URL | grep -v '^#' | grep ' ; fully-qualified ' | cut -d'#' -f2 > $FILE
    fi
}

get_emojis

emoji=$(cat "$FILE" | fuzzel-themed.sh -d -p " Search Emoji: ")
emoji_icon=$(echo $emoji | cut -d ' ' -f1)
wtype "$emoji_icon"

