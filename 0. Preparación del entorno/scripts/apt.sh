#!/usr/bin/bash

echo -e "\nAPT Updating..."
echo "~~~~~~~~~~~~~~~"
sudo apt update

echo -e "\nAPT Upgrading..."
echo "~~~~~~~~~~~~~~~~"
sudo apt upgrade -y

if [ $# -gt 0 ] ; then
    for pkg in "$@"; do
        echo -e "\nAPT Installing ${pkg}..."
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        sudo apt install -y "$pkg"
    done
fi

echo -e "\nAPT Autoremoving..."
echo "~~~~~~~~~~~~~~~~~~~"
sudo apt autoremove -y

echo -e "\n"
