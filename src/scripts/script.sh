#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CONFIG_FILE="${SCRIPT_DIR}/../../archConfigs/configurationFiles/config.txt"
DOTFILES_DIR="${SCRIPT_DIR}/../../archConfigs/configurationFiles"

echo "Script Directory: $SCRIPT_DIR"
echo "Config File: $CONFIG_FILE"
echo "Dotfiles Directory: $DOTFILES_DIR"

backup() {
    local src=$1
    local dest=$2
    echo "Backup: src=$src, dest=$dest"
    if [ -d "$src" ]; then
        cp -r "$src" "$dest"
    elif [ -f "$src" ]; then
        cp "$src" "$dest"
    else
        echo "Quelle $src existiert nicht."
    fi
}

restore() {
    local src=$1
    local dest=$2
    echo "Restore: src=$src, dest=$dest"
    ln -sfn "$src" "$dest"
}

remove() {
    local target=$1
    echo "Remove: target=$target"
    if [ -d "$target" ] || [ -f "$target" ]; then
        echo "Vor dem Entfernen: $target existiert und wird jetzt entfernt."
        rm -rf "$target"
        echo "Nach dem Entfernen: $target wurde entfernt."
    else
        echo "Ziel $target existiert nicht."
    fi
}


expand_path() {
    local path=$1
    if [[ $path == "~"* ]]; then
        path="${HOME}${path:1}"
    fi
    echo $path
}

while IFS=':' read -r key path; do
    echo "Processing: key=$key, original_path=$path"
    echo "Expanding path: original=$path"
    path=$(expand_path "$path")
    echo "Expanded path: result=$path"
    dest_path="${DOTFILES_DIR}/${key}"
    echo "After expansion: path=$path, dest_path=$dest_path"
    case $1 in
        backup)
            [ "$2" == "$key" ] || [ -z "$2" ] && backup "$path" "$dest_path"
            ;;
        restore)
            [ "$2" == "$key" ] || [ -z "$2" ] && restore "$dest_path" "$path"
            ;;
        remove)
            [ "$2" == "$key" ] || [ -z "$2" ] && remove "$path"
            ;;
        *)
            echo "Ungültiger Befehl. Verwenden Sie 'backup', 'restore' oder 'remove'."
            exit 1
            ;;
    esac
done < "$CONFIG_FILE"
