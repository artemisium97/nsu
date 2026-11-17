#!/usr/bin/env bash

: > server.conf

for var in SERVER_NAME MAX_PLAYERS SPAWN_COORDS; do
    value="${!var}"

    if [[ -z "$value" ]]; then
        if   [[ "$var" == "SERVER_NAME"  ]]; then value="StarCraft"
        elif [[ "$var" == "MAX_PLAYERS"  ]]; then value="125"
        elif [[ "$var" == "SPAWN_COORDS" ]]; then value="274 67 -249"
        fi
    fi

    echo "${var}=\"${value}\"" >> server.conf
done

cat server.conf
