#!/usr/bin/env bash

i3status --config /etc/i3status.conf | while :
do
    read line
    LG=$(xset -q | grep -A 0 'LED' | cut -c59-67)
    if [ $LG == "00000002" ]; then
        echo "$line | LG: en" || exit 1

    elif [ $LG == "00000003" ]; then
        echo "$line | LG: EN" || exit 1

    elif [ $LG == "000010002" ]; then
        echo "$line | LG: he" || exit 1

    elif [ $LG == "0000100003" ]; then
        echo "$line | LG: HE" || exit 1
    fi
done
