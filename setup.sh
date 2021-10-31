#!/bin/bash

#
# psx-pi-smbshare setup script
#
# *What it does*
# This script will install and configure an smb share at /share
# It will also compile ps3netsrv from source to allow operability with PS3/Multiman
# Finally, it configures the pi ethernet port to act as dhcp server for connected devices and allows those connections to route through wifi on wlan0
#
# *More about the network configuration*
# This configuration provides an ethernet connected PS2 or PS3 a low-latency connection to the smb share running on the raspberry pi
# The configuration also allows for outbound access from the PS2 or PS3 if wifi is configured on the pi
# This setup should work fine out the box with OPL and multiman
# Per default configuration, the smbserver is accessible on 192.168.2.1

# Update packages
sudo apt-get -y update
sudo apt-get -y upgrade

# Install and configure Samba
sudo apt-get install -y samba samba-common-bin
wget https://raw.githubusercontent.com/abauer186/psx-pi-smbshare/master/samba-init.sh -O /home/pi/samba-init.sh
chmod 755 /home/pi/samba-init.sh
sudo cp /home/pi/samba-init.sh /usr/local/bin
sudo mkdir -m 1777 /share

# Install USB automount settings
wget https://raw.githubusercontent.com/abauer186/psx-pi-smbshare/master/automount-usb.sh -O /home/pi/automount-usb.sh
chmod 755 /home/pi/automount-usb.sh
sudo /home/pi/automount-usb.sh

# Set samba-init + ps3netsrv, wifi-to-eth-route, setup-wifi-access-point, and Xlink Kai to run on startup
{ echo -e "@reboot sudo bash /usr/local/bin/samba-init.sh\n@reboot"; } | crontab -u pi -

# Start services
sudo /usr/local/bin/samba-init.sh

# Not a bad idea to reboot
sudo reboot
