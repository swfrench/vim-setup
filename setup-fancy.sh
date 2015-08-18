#!/bin/bash -v

set -e

ts=$(date "+%Y%m%d%H%M%S")

[[ -d ~/.vim ]] && mv ~/.vim ~/.vim.keep.$ts
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.keep.$ts

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle && \
	git clone git://github.com/tpope/vim-sensible.git && \
	git clone https://github.com/scrooloose/syntastic.git && \
	git clone git://github.com/tpope/vim-fugitive.git && \
	git clone https://github.com/bling/vim-airline.git && \
	git clone https://github.com/edkolev/tmuxline.vim && \
	git clone https://github.com/tomasr/molokai.git

cat << END > ~/.vimrc
execute pathogen#infect()

inoremap jk <esc>

set hlsearch

colorscheme molokai

let g:airline_powerline_fonts = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
END
