#!/bin/bash
CONFIG_FILE="archConfigs/configurationFiles/config.txt"

DOTFILES_DIR="${HOME}/git/dotfiles/archConfigs/configurationFiles"

if [ -f "$DOTFILES_DIR/archConfigs/configurationFiles/.dotfiles_config" ]; then
    source "$HOME/archConfigs/configurationFiles/.dotfiles_config"
fi

backup() {
    local src=$1
    local dest=$2
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
    ln -sfn "$src" "$dest"
}

remove() {
    local target=$1
    if [ -d "$target" ] || [ -f "$target" ]; then
        rm -rf "$target"
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

while read -r key path; do
    path=$(expand_path $path)
    dest_path="$DOTFILES_DIR/$key"
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
done < $CONFIG_FILE
