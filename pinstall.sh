#!/bin/bash
echo "Enter program name"
read file
if [ ! -e $file ]; then
  echo "Program not found!"
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
