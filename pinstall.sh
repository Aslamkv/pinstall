#!/bin/bash
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

  sudo chmod +x $file
  sudo mkdir /usr/bin/$folder
  sudo cp $file /usr/bin/$folder
  if ls *.conf 1> /dev/null 2>&1; then
    echo "Installing configurations"
    for conf in *.conf; do sudo cp $conf /usr/bin/$folder ;done
  fi
  sudo ln -s /usr/bin/$folder/$file /usr/bin/$symlink
  if [ $? -eq 0 ]; then
    echo "Installed $symlink :)"
  else
    echo "Installation of $symlink failed :("
  fi
}

remove (){
  folder=$1
  symlink=$2
  if [ -d /usr/bin/$folder ]; then
    echo "Removing existing $symlink"
    sudo rm -fr /usr/bin/$folder/
    sudo rm -f /usr/bin/$symlink
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
  list=`ls -d /usr/bin/.[A-z]* 2> /dev/null | sed 's/^.*\.//g' `
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
