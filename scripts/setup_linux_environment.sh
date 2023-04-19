#!/bin/bash

# If you are using your own linux build, such as a WSL image, then this will install the required packages.
# Otherwise, ensure conda is installed manually

# Can run this in your main ~/ directory if you wish.
# # install conda manually, which might even be on .  For example,
wget  https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh
bash Anaconda3-2023.03-Linux-x86_64.sh
rm Anaconda3-2023.03-Linux-x86_64.sh

source ~/.bashrc  # Can't hurt to reload any environment variables from conda

# ensure related packages are installed
sudo apt update
sudo apt-get --assume-yes upgrade
sudo apt install -y make gcc unzip
sudo apt-get --assume-yes update
sudo apt install -y g++
sudo apt-get install libxt6 libxrender1 libgl1-mesa-glx libqt5widgets5 # at least for WSL?
sudo apt install tmux