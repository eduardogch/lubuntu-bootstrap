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

sudo apt-get install -y samba samba-common system-config-samba python-glade2 ssh x11vnc

sudo apt-get install -y python-software-properties python-pip pkg-config software-properties-common xbmc popcorn-time

sudo apt-get -y install lm-sensors hddtemp psensor thermald
sudo dpkg-reconfigure hddtemp
sudo sensors-detect
sudo service kmod start


# *|*|*|*|*|*|*|*|*|*| Config or install apps *|*|*|*|*|*|*|*|*|*|* # 

### Config VNC ### 
sudo ufw disable
sudo ufw status
sudo x11vnc -storepasswd /etc/x11vnc.pass

sudo nano  /etc/init/x11vnc.conf
start on login-session-start
script
/usr/bin/x11vnc -xkb -auth /var/run/lightdm/root/:0 -noxrecord -noxfixes -noxdamage -rfbauth /etc/x11vnc.pass -forever -bg -rfbport 5900 -o /var/log/x11vnc.log
end script

sudo nano /etc/lxdm/default.conf
xauth_path=/tmp

sudo nano /etc/lxdm/LoginReady
#!/bin/sh
/usr/bin/x11vnc -xkb -auth /tmp/.Xauth1000 -noxrecord -noxfixes -noxdamage -rfbauth /etc/x11vnc.pass -forever -bg -rfbport 5900 -o /var/log/x11vnc.log


###  Config Samba ### 
sudo nano /etc/samba/smb.conf
#add this to the very end of the file:

[pozole]
path = /home/pozole
available = yes
valid users = pozole
read only = no
browseable = yes
public = yes
writable = yes
comment = Rico Pozole

sudo restart smbd

###  Install No-IP ### 
wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
tar -zxvf noip-duc-linux.tar.gz
cd noip-2.1.9-1/
make
sudo make install
sudo noip2 -S
ps aux | grep noip2


### Install Flirc ### 
sudo nano /etc/apt/sources.list
#Add to the last line
deb http://apt.flirc.tv/arch/x64 binary/

sudo apt-get -y update 
sudo apt-get -y install flirc 


### Config rc.local ### 
sudo nano /etc/rc.local

/usr/local/bin/noip2
xset s off && xset -dpms


###  Disable Errors ### 
sudo nano /etc/default/apport
Change the value to 0


###  Config Cron ### 
export EDITOR=nano
crontab -e
# Added this lines at the bottom
@hourly /usr/local/bin/flexget execute --cron
@hourly root apt-get update && apt-get -y upgrade
@hourly root apt-get -f install && apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean


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


###  Config Transmission ###
sudo service transmission-daemon stop
sudo nano /etc/transmission-daemon/settings.json

{
    "alt-speed-down": 300,
    "alt-speed-enabled": true,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": true,
    "alt-speed-time-end": 1425,
    "alt-speed-up": 30,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": true,
    "blocklist-url": "http://list.iblocklist.com/?list=bt_level1&fileformat=p2p",
    "cache-size-mb": 4,
    "dht-enabled": true,
    "download-dir": "/home/pozole/Downloads",
    "download-limit": 100,
    "download-limit-enabled": 0,
    "download-queue-enabled": true,
    "download-queue-size": 5,
    "encryption": 1,
    "idle-seeding-limit": 5,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/home/pozole/Downloads/Incomplete",
    "incomplete-dir-enabled": false,
    "lpd-enabled": false,
    "max-peers-global": 200,
    "message-level": 2,
    "peer-congestion-algorithm": "",
    "peer-limit-global": 100,
    "peer-limit-per-torrent": 30,
    "peer-port": 45245,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": true,
    "port-forwarding-enabled": true,
    "preallocation": 1,
    "prefetch-enabled": 1,
    "queue-stalled-enabled": true,
    "queue-stalled-minutes": 30,
    "ratio-limit": 0.1000,
    "ratio-limit-enabled": false,
    "rename-partial-files": true,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-password": "{218da7a1f7d22441cd6ac02d2fedc59087c66808TLC1Kmir",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "pozole",
    "rpc-whitelist": "127.0.0.1",
    "rpc-whitelist-enabled": false,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": false,
    "script-torrent-done-filename": "",
    "seed-queue-enabled": false,
    "seed-queue-size": 10,
    "speed-limit-down": 100,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 70,
    "speed-limit-up-enabled": true,
    "start-added-torrents": true,
    "trash-original-torrent-files": false,
    "umask": 18,
    "upload-limit": 100,
    "upload-limit-enabled": 0,
    "upload-slots-per-torrent": 14,
    "utp-enabled": true,
    "watch-dir": "/home/pozole/Downloads/Torrents",
    "watch-dir-enabled": true
}


###  Install Flexget ### 
sudo pip install flexget
sudo mkdir .flexget
cd .flexget
sudo nano /home/pozole/.flexget/config.yml

# Contenido Archivo

tasks:
  tv tasks:
    rss: http://www.torrentday.com/torrents/rss?download;l2;u=1323865;tp=3254b0e8fd13cc01a47daf9a0a66784b
    series:
      - the soup
      - wheeler dealers
      - wipeout
      - gold rush
      - hells kitchen
      - kitchen nightmares
      - south park
      - the big bang theory
      - two and a half men
      - game of thrones
      - the simpsons
      - storage wars
      - shipping wars
      - click
      - gadget show
      - pawn stars
      - mythbusters
      - regular show
      - extreme weight loss
      - masterchef
      - cosmos
      - family guy
      - silicon valley
      - how its made
      - heavy metal monsters
      - undercover boss
      - the amazing race
      - counting cars
      - ninja warrior
      - jobs that dont suck
    download: /home/pozole/Downloads/Torrents/

sudo chmod -R 777 /home/pozole/.flexget
flexget execute


###  Fix problem screensaver ###
xset s off && xset -dpms
sudo xset s off && xset -dpms
sudo rm /etc/xdg/autostart/light-locker.desktop

sudo nano /etc/X11/xorg.conf.d

Section "ServerFlags"
Option "BlankTime" "0"
Option "StandbyTime" "0"
Option "SuspendTime" "0"
Option "OffTime" "0"
EndSection

###  Added xmbc autorun with GUI ###
#Go to menu in LXDE session and in startup programs add
#/usr/bin/xbmc

###  Config Samba with GUI ###
#Go to samba and add a user


# *|*|*|*|*|*|*|*|*|*| Clean up this mess *|*|*|*|*|*|*|*|*|*|* #
sudo apt-get -f install
sudo apt-get autoremove
sudo apt-get -y autoclean
sudo apt-get -y clean
