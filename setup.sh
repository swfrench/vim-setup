#!/bin/sh

# date stamp for backups
date_stamp=`date "+%Y%m%d%H%M%S"`

backup () {
	dst=$1.$date_stamp
	if [ -e $dst ]
	then
		printf "Backup target %s already exists - aborting\n" $dst
		exit 1
	fi
	mv $1 $dst
	printf "Moved %s to %s\n" $1 $dst
}

get_dep_path () {
	# extract leading path from arg
	dep_path=`dirname $1`
	# enter leading path dir and run pwd, returning result to stdout
	cd $dep_path
	pwd
}

# make sure this is invoked from the home directory
wd=`pwd`
if [ "$wd" != "$HOME" ]
then
	printf "This is not %s's home directory - aborting\n" "$USER"
	exit 1
fi

# get path to this script and associated deps
dep_path=$(get_dep_path $0)

# backup existing config
[ -d .vim ] && backup .vim
[ -f .vimrc ] && backup .vimrc

# copy in new configs
mkdir .vim
cp $dep_path/vimrc .vimrc
cp -r $dep_path/ftplugin .vim/

# set up pathogen
mkdir .vim/autoload .vim/bundle
curl -Sso .vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# fetch plugins
cd .vim/bundle
git clone https://github.com/tpope/vim-sensible
git clone https://github.com/tpope/vim-fugitive
git clone https://github.com/Shougo/neocomplcache.vim
git clone https://github.com/scrooloose/syntastic
git clone https://github.com/tomasr/molokai
