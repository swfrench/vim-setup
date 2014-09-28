#!/bin/sh -v

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
	if [ -e $1 ]
	then
		if [ -e $2 ]
		then
			printf "Backup target %s already exists - aborting\n" $2
			exit 1
		fi
		# copy to backup dest
		cp -R $1 $2
		printf "Backed up %s to %s\n" $1 $2
	fi
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
dep_path=`get_dep_path $0`

# backup existing config
backup .vim .vim.$date_stamp
backup .vimrc .vimrc.$date_stamp

# clean up (possibly) existing .vim/
rm -rf .vim/*

# copy in new configs
cp $dep_path/vimrc .vimrc
cp -R $dep_path/ftplugin .vim/

# set up pathogen
mkdir .vim/autoload .vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim \
	https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# fetch plugins etc...
cd .vim/bundle
for repo in $pathogen_repos
do
	git clone $pathogen_repo_host/$repo
done
