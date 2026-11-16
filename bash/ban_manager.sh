#!/usr/bin/env bash

BANLIST="banlist.txt"

format() {
    local file="$1"

    if [[ -z "$file" || ! -f "$file" ]]; then
        echo "Invalid file" >&2
        return 1
    fi

    sed '/^11_Steve_11 /d' "$file" | sort | uniq > "$file.tmp"
    mv "$file.tmp" "$file"
}

add() {
    local nickname time reason

    if [[ $# -eq 3 ]]; then
        nickname="$1"; time="$2"; reason="$3"
    elif [[ $# -eq 1 ]]; then
        set -- $1
        nickname="$1"; time="$2"; shift 2; reason="$*"
    else
        echo "Usage: add <nickname> <time> <reason>" >&2
        return 1
    fi

    local entry="${nickname} ${time} ${reason}"

    while IFS= read -r line; do
        if [[ "$line" == "$entry" ]]; then
            echo "Already banned: $entry" >&2
            return 0
        fi
    done < "$BANLIST"

    echo "$entry" >> "$BANLIST"
}

info() {
    local nickname="$1"

    if [[ -z "$nickname" ]]; then
        echo "Usage: info <nickname>" >&2
        return 1
    fi

    sed -n "/^${nickname} /p" "$BANLIST"
}

remove() {
    local nickname="$1"

    if [[ -z "$nickname" ]]; then
        echo "Usage: remove <nickname>" >&2
        return 1
    fi

    sed "/^${nickname} /d" "$BANLIST" > "$BANLIST.tmp"
    mv "$BANLIST.tmp" "$BANLIST"
}

sort_list() {
    local mode="$1"
    local file="$2"

    if [[ -z "$file" || ! -f "$file" ]]; then
        echo "Invalid file" >&2
        return 1
    fi

    case "$mode" in
        --name)
            sort -k1,1 "$file" > "${file}.sorted"
            ;;
        --time)
            sort -k2,2 "$file" > "${file}.sorted"
            ;;
        *)
            echo "Usage: sort --name|--time <file>" >&2
            return 1
            ;;
    esac

    mv "${file}.sorted" "$file"
}

action="$1"
shift

case "$action" in
    format)  format "$@" ;;
    add)     add "$@" ;;
    info)    info "$@" ;;
    remove)  remove "$@" ;;
    sort)    sort_list "$@" ;;
    *)
        echo "Usage: $0 {format|add|info|remove|sort} ..." >&2
        exit 1
        ;;
esac
