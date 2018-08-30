#!/bin/bash
args=$#
if [  $args -lt 1 ]; then
  echo "Usage: pinstall <shell_file>"
  exit;
fi
file=$1
if [ ! -e $file ]; then
  echo "Shell script not found!"
  exit;
fi
symlink=${file/\.sh/}
folder=".$symlink"
sudo chmod +x $file
if [ -d /usr/bin/$folder ]; then
  echo "Removing existing $symlink"
  sudo rm -fr /usr/bin/$folder/
  sudo rm -fr /usr/bin/$symlink
fi
sudo mkdir /usr/bin/$folder
sudo cp $file /usr/bin/$folder
if ls *.conf 1> /dev/null 2>&1; then
  for conf in *.conf; do sudo cp $conf /usr/bin/$folder ;done
fi
sudo ln -s /usr/bin/$folder/$file /usr/bin/$symlink
if [ $? -eq 0 ]; then
  echo "Installed $symlink :)"
else
  echo "Installation of $symlink failed :("
fi
