#!/bin/bash
### ARCHIVE EXTRACTION
# usage: ex <file>
if [[ -f "$1" ]]; then
    case "$1" in
        *.tar.bz2)   mkdir -p "$(basename -s '.tar.bz2' "$1")" && tar xjf "$1" -C "$_"   ;;
        *.tar.gz)    mkdir -p "$(basename -s '.tar.gz' "$1")" && tar xzf "$1" -C "$_"   ;;
        *.bz2)       bunzip2 "$1"   ;;
        *.rar)       unrar x "$1"   ;;
        *.gz)        gunzip "$1"    ;;
        *.tar)       mkdir -p "$(basename -s '.tar' "$1")" && tar xf "$1" -C "$_"   ;;
        *.tbz2)      mkdir -p "$(basename -s '.tbz2' "$1")" && tar xjf "$1" -C "$_"   ;;
        *.tgz)       mkdir -p "$(basename -s '.tgz' "$1")" && tar xzf "$1" -C "$_"   ;;
        *.zip)       unzip "$1" -d $(basename -s .zip "$1")     ;;
        *.Z)         uncompress "$1";;
        *.7z)        7z x "$1"      ;;
        *.deb)       ar x "$1"      ;;
        *.tar.xz)    mkdir -p "$(basename -s '.tar.xz' "$1")" && tar xf "$1" -C "$_"   ;;
        *.tar.zst)   unzstd "$1"    ;;
        *)           echo "'"$1"' cannot be extracted via ex()" ;;
    esac
else
    echo "'$1' is not a valid file"
fi
