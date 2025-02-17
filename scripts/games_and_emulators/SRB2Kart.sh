#!/bin/bash

cd ~
clear -x
status "SRB2 Kart script started!"
status "Downloading the files, and installing needed dependencies..."
sleep 2
sudo rm -r /usr/share/SRB2Kart
cd ~/.srb2kart
#rm kartconfig.cfg
cd /usr/share/applications
sudo rm "SRB2 Kart.desktop"
cd
sudo apt install wget curl libsdl2-dev libsdl2-mixer-dev cmake extra-cmake-modules subversion libupnp-dev libgme-dev libopenmpt-dev curl libcurl4-gnutls-dev libpng-dev p7zip-full libgles2-mesa-dev -y || error "Dependency installs failed"
wget https://github.com/STJr/Kart-Public/archive/master.zip --progress=bar:force:noscroll
unzip master.zip
svn export https://github.com/$repository_username/L4T-Megascript/trunk/assets/SRB2Kart
mkdir -p SRB2Kart-Data && cd SRB2Kart-Data
wget $(curl --silent "https://api.github.com/repos/STJr/Kart-Public/releases/latest" | grep "Installer" | grep ".exe" | cut -c 31- | cut -d '"' -f 2) -O SRB2Kart.exe
7z x SRB2Kart.exe
cd ~/Kart-Public-master/assets
mkdir -p installer
cd ~/SRB2Kart-Data
mv chars.kart bonuschars.kart gfx.kart maps.kart patch.kart music.kart sounds.kart srb2.srb textures.kart -t ~/Kart-Public-master/assets/installer
cd ~/Kart-Public-master
mkdir -p build && cd build
status "Compiling the game..."
cmake ..
make -j$(nproc) || error "Compilation failed"
status_green "Game compiled!"
cd ~
status "Erasing temporary build files to save space, installing the direct access and configuration files....."
mkdir -p .srb2kart
rm -r SRB2Kart-Data
cd SRB2Kart
chmod 777 SRB2Kart.sh
mv kartconfig.cfg -t ~/.srb2kart
sudo mv "SRB2 Kart.desktop" -t /usr/share/applications
cd ~/Kart-Public-master
mv assets -t ~/SRB2Kart
cd ~/Kart-Public-master/build
mv bin -t ~/SRB2Kart
cd ~
rm master.zip*
rm -r Kart-Public-master
sudo mv SRB2Kart -t /usr/share
echo
status_green "Game Installed!"
warning "[NOTE] Remember NOT to move the SRB2Kart folder or any file inside it or the game will stop working."
warning "If the game icon doesn't appear inmediately, restart the system."
status "This message will close in 10 seconds."
sleep 10
status "Sending you back to the main menu..."
