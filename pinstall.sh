#!/bin/bash
bin_path=$HOME/.pinstall/

if [ ! -d "$bin_path" ]; then
  mkdir $bin_path
  exists=`cat ~/.bashrc | grep .pinstall`
  if [ -z "$exists" ]; then
    echo 'Adding path to bashrc'
    echo '' >> ~/.bashrc
    echo '#add pinstall bin path in $PATH' >> ~/.bashrc
    echo "export PATH=\"\$PATH:\$HOME/.pinstall\"" >> ~/.bashrc
    PATH="$PATH:$HOME/.pinstall"
  fi
fi

file_exists (){
  file=$1
  if [ ! -e $file ]; then
    echo "Shell script not found!"
    exit;
  fi
}

install (){
  file=$1
  file_exists $file

  symlink=${file/\.sh/}
  folder=".$symlink"

  remove $folder $symlink

  chmod +x $file
  mkdir $bin_path$folder
  cp $file $bin_path$folder
  if ls *.conf 1> /dev/null 2>&1; then
    echo "Installing configurations"
    for conf in *.conf; do cp $conf $bin_path$folder ;done
  fi
  ln -s $bin_path$folder/$file $bin_path$symlink
  if [ $? -eq 0 ]; then
    echo "Installed $symlink :)"
  else
    echo "Installation of $symlink failed :("
  fi
}

remove (){
  folder=$1
  symlink=$2
  if [ -d $bin_path$folder ]; then
    echo "Removing existing $symlink"
    rm -fr $bin_path$folder/
    rm -f $bin_path$symlink
    return 0
  fi
  return 1
}

args=$#
if [  $args -lt 1 ]; then
  echo "Usage"
  echo "Installation: pinstall <shell_file>"
  echo "List Installed scripts: pinstall list"
  echo "Removal: pinstall remove <shell_file>"
  exit;
fi
if [ "$1" == "remove" ]; then
  file=$2
  symlink=${file/\.sh/}
  folder=".$symlink"
  remove $folder $symlink
  if [ $? -eq 1 ]; then
    echo "$symlink does not exist!"
    exit;
  fi
  echo "Uninstalled $symlink"
  exit;
fi
if [ "$1" == "list" ]; then
  list=`ls -d $bin_path.[A-z]* 2> /dev/null | sed 's/^.*\.//g' `
  total=${#list}
  if [ $total -lt 1 ]; then
    echo "No Installed scripts found"
    exit;
  fi
  echo "Installed scripts"
  echo $list
  exit;
fi
if [  $args -eq 1 ]; then
  echo "Preparing Installation"
  install $1
fi
