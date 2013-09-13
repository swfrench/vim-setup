#!/bin/sh

########
# config

# date stamp for backups
date_stamp=`date "+%Y%m%d%H%M%S"`

# repos for pathogen
pathogen_repo_host="https://github.com"
pathogen_repos="
  tpope/vim-sensible
  tpope/vim-fugitive
  Shougo/neocomplcache.vim
  scrooloose/syntastic
  tomasr/molokai"


###################
# support functions

backup () {
	# infer dest name; check for existence
	dst=$1.$date_stamp
	if [ -e $dst ]
	then
		printf "Backup target %s already exists - aborting\n" $dst
		exit 1
	fi
	# move to backup dest
	mv $1 $dst
	printf "Moved %s to %s\n" $1 $dst
}

get_dep_path () {
	# extract and enter leading path from arg
	cd `dirname $1`
	# run pwd, returning result to stdout
	pwd
}


#############
# main script

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

# fetch plugins etc...
cd .vim/bundle
for repo in ${pathogen_repos[@]}
do
	git clone $pathogen_repo_host/$repo
done
