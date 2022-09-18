#!/bin/bash

background="0x222222cc"
border="0xdd1bda"
urgent="0xb6026b"
occupied="$background"

river-tag-overlay \
    --border-width 1 \
    --square-size 24 \
    --square-inner-padding 3 \
    --square-padding 8 \
    --square-border-width 1 \
    --margins 2:2:2:2 \
    --background-colour "$background" \
    --border-colour "$border" \
    --square-active-border-colour "$border" \
    --square-urgent-border-colour "$urgent" \
    --square-active-background-colour "$background" \
    --square-inactive-background-colour "$background" \
    --square-urgent-background-colour "$background" \
    --square-active-occupied-colour "$occupied" \
    --square-inactive-occupied-colour "$occupied" \
    --square-urgent-occupied-colour "$urgent" \

