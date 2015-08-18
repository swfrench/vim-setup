#!/bin/bash -v

set -e

ts=$(date "+%Y%m%d%H%M%S")

[[ -d ~/.vim ]] && mv ~/.vim ~/.vim.keep.$ts
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.keep.$ts

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle && \
	git clone git://github.com/tpope/vim-sensible.git && \
	git clone git://github.com/tpope/vim-fugitive.git

cat << END > ~/.vimrc
execute pathogen#infect()

inoremap jk <esc>

set hlsearch

set laststatus=2
set statusline=%<%f\ %h%m%r\ %{fugitive#statusline()}%=%-14.([%l/%L,%c]%)\ %P
END
