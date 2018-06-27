#!/bin/bash
echo "Enter shell script name"
read file
if [ ! -e $file ]; then
  echo "Shell script not found!"
  exit;
fi
symlink=${file/\.sh/}
sudo chmod +x $file
sudo cp $file /usr/bin/
if [ -e /usr/bin/$symlink ]; then
  echo "Removing existing symlink"
  sudo rm -r /usr/bin/$symlink
fi
sudo ln -s /usr/bin/$file /usr/bin/$symlink
if [ $? -eq 0 ]; then
  echo "Installed $symlink :)"
else
  echo "Installation of $symlink failed :("
fi
