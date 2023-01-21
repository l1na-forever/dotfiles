#!/bin/bash
# From https://github.com/galizur/.dotfiles

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
$(echo -n "$emoji_icon" | wl-copy)

dunstify -h string:x-canonical-private-synchronous:emoji \
            "$emoji_icon copied to clipboard"

