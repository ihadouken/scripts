#!/bin/bash

readarray -t colors < <(/usr/bin/ls "$HOME/.vim/plugged/lightline.vim/autoload/lightline/colorscheme/" | xargs basename -s '.vim')
printf "%s\n" "${colors[@]}"

choice="$(printf '%s\n' "${colors[@]}" | dmenu -l 20 -i -fn Mononoki-nerd-font -p 'Lightline Theme: ')"

if [[ -z "$choice" ]]; then
    printf "\n\033[1;33m*** No Lightline color given.\033[0m\n\n"
else
    sed -i "s/'colorscheme': '.*',/'colorscheme': '$choice',/" "/home/hadouken/.config/nvim/init.vim"
    echo "Applied $choice to neovim lightline"
fi
