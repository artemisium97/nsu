#!/usr/bin/env bash

log="$1"

if [[ -z "$log" || ! -f "$log" ]]; then
    echo "Usage: $0 <transactions.log>" >&2
    exit 1
fi

awk '
{
    spent[$1] += $4
    earned[$3] += $4
}
END {
    for (player in spent)
        if (spent[player] > earned[player])
            print player
}
' "$log"
