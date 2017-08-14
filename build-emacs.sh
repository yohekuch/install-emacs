#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS and newer
# version: 25.2
# Toolkit: default - gtk-3

set -eu

readonly version="25.2"

if emacs --version | head -n 1 | grep -iE "GNU Emacs $version" ; then
    echo Emacs "$version" is already installed.
    exit 0
fi

# install dependencies
printf "Installing dependencies... "
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev \
     libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev \
     libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev \
     libxml2-dev libgpm-dev libotf-dev libm17n-dev \
     libgnutls-dev wget
printf "done.\n"

# download source package
cd ~/Downloads
if [[ ! -d emacs-"$version" ]]; then
   printf "Downloading GNU Emacs... "
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
   printf "done.\n"
fi

# build and install
echo "Building and installing GNU Emacs... "
sudo mkdir -p /usr/local/stow
cd emacs-"$version"

./configure
make
sudo make install prefix=/usr/local/stow/emacs-"$version"

cd /usr/local/stow
sudo stow emacs-"$version"

echo "All done."
