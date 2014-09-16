#!/bin/bash
#
# Desing for Lubuntu 14.04
# Lubuntu bootstrap - A simple script to have ready my ubuntu.
#
# Download:
# wget https://raw.githubusercontent.com/eduardogch/ubuntu-bootstrap/master/Lubuntu_bootstrap.sh


# Update repos and packages.
sudo apt-get -y update 
sudo apt-get -y upgrade

sudo add-apt-repository -y ppa:transmissionbt/ppa
sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo add-apt-repository -y ppa:webupd8team/popcorntime
sudo apt-get -y update 


# *|*|*|*|*|*|*|*|*|*| Install most important apps *|*|*|*|*|*|*|*|*|*|* # 

sudo apt-get install -y unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller

sudo apt-get install -y gksu synaptic pavucontrol linux-firmware-nonfree pepperflashplugin-nonfree lubuntu-restricted-extras pithos build-essential transmission-daemon transmission-common transmission-cli

sudo apt-get install samba samba-common system-config-samba python-glade2 tightvncserver autocutsel

sudo apt-get install -y python-software-properties python-pip pkg-config software-properties-common xbmc popcorn-time

sudo apt-get -y install lm-sensors hddtemp psensor thermald
sudo dpkg-reconfigure hddtemp
sudo sensors-detect
sudo service kmod start


# *|*|*|*|*|*|*|*|*|*| Config or install apps *|*|*|*|*|*|*|*|*|*|* # 

### Config VNC ### 
tightvncserver :1
tightvncserver -kill :1

# Add at the final line 
nano  ~/.vnc/xstartup

#!/bin/sh

#xrdb $HOME/.Xresources
xsetroot -solid grey

#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &

export XKL_XMODMAP_DISABLE=1
autocutsel -fork
openbox &
/usr/bin/lxsession -s Lubuntu -e LXDE &


tightvncserver :1

# To run tightvncserver at startup
sudo nano /etc/init.d/tightvncserver

#!/bin/sh
### BEGIN INIT INFO
# Provides: tightvncserver
# Required-Start: $local_fs
# Required-Stop: $local_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start/stop tightvncserver
### END INIT INFO
	
### Customize this entry
# Set the USER variable to the name of the user to start tightvncserver under
export USER=’pozole‘
### End customization required
	
eval cd ~$USER
	
case “$1″ in
start)
su $USER -c ‘/usr/bin/tightvncserver :1′
echo “Starting TightVNC server for $USER “
;;
stop)
pkill Xtightvnc
echo “Tightvncserver stopped”
;;
*)
echo “Usage: /etc/init.d/tightvncserver {start|stop}”
exit 1
;;
esac
exit 0


sudo chmod 775 /etc/init.d/tightvncserver
sudo update-rc.d tightvncserver defaults

###  Install No-IP ### 
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar -zxvf noip-duc-linux.tar.gz
cd noip-2.1.9-1/
make
sudo make install

sudo nano /etc/rc.local
# Added this line before any instance of exit 0
/usr/local/bin/noip2

###  Install Flexget ### 
sudo pip install f
lexget
sudo mkdir .flexget
cd .flexget
sudo nano /home/xbian/.flexget/config.yml

###  Config Cron ### 
export EDITOR=nano
crontab -e
# Added this lines at the bottom
@hourly /usr/local/bin/flexget execute --cron
@daily root apt-get update && apt-get -y upgrade
@daily /home/UServer/Documents/script_eliminar_archivos_viejos.sh

###  Install Dropbox ### 
# Download .deb from https://www.dropbox.com/install?os=lnx
sudo gdebi dropbox_1.6.2_amd64.deb

###  Install Google Chrome ###
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

###  Install Jenkins ###

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
#Change port
http://blog.htxiong.com/2013/06/install-jenkins-on-ubuntu-and-setting.html

###  Install GitLab ###

sudo apt-get install -y postfix openssh-server
wget https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/gitlab_7.1.1-omnibus-1_amd64.deb
sudo dpkg -i gitlab_7.1.1-omnibus-1_amd64.deb

sudo nano /etc/gitlab/gitlab.rb
http://gitlab.pozole.noip.me

sudo gitlab-ctl reconfigure
sudo gitlab-ctl status

# *|*|*|*|*|*|*|*|*|*| Clean up this mess *|*|*|*|*|*|*|*|*|*|* #
sudo apt-get -f install
sudo apt-get autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean