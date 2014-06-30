#!/bin/bash

# script to run for new VMs so that they act as rstudio servers

# Define some variables for use in the following script
REMOTE_UBUNTU_PASSWORD='acpfgRworkshop2014'
REMOTE_USER_USERNAME='new_username'
REMOTE_USER_FULL_NAME='Full Name of New User'
REMOTE_USER_PASSWORD='secure_new_user_password'
TIMEZONE='Australia/Adelaide'
FIREFOX_LINK_URL='http://australianbioinformatics.net/'
#####

# Update the ubuntu user's password
echo -e "ubuntu:${REMOTE_UBUNTU_PASSWORD}" | chpasswd

# add a cran repository
echo -e "\n# CRAN repository for RStudio\n" >> /etc/apt/sources.list
echo deb http://cran.csiro.au/bin/linux/ubuntu precise/ >> /etc/apt/sources.list

# add a key reqd for the CRAN packages
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# start with up-to-date package libraries
apt-get update 

# Add the trainee user and set the account password
useradd --shell /bin/bash --create-home --comment "${REMOTE_USER_FULL_NAME}" ${REMOTE_USER_USERNAME}
echo -e "${REMOTE_USER_USERNAME}:${REMOTE_USER_PASSWORD}" | chpasswd

# Set the time zone
#####
echo "${TIMEZONE}" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Install a bunch of packages from the repositories
#####
apt-get install -y \
  r-base \
  r-base-dev \
  gdebi-core \
  libapparmor1 
  
# install rstudio server
wget http://download2.rstudio.org/rstudio-server-0.98.945-amd64.deb
gdebi --n rstudio-server-0.98.945-amd64.deb  

# Add some desktop links
#####
# First, ensure the user has a Desktop directory into which we'll put these files
if [[ ! -e "/home/${REMOTE_USER_USERNAME}/Desktop" ]]; then
  mkdir --mode=755 /home/${REMOTE_USER_USERNAME}/Desktop
fi

# Add a Firefox shortcut to ${FIREFOX_LINK_URL} onto the desktop and make it executable
#####
echo "[Desktop Entry]
Name=Australian Bioinformatics Network
Type=Application
Encoding=UTF-8
Comment=Link to Australian Bioinformatics Network
Exec=firefox ${FIREFOX_LINK_URL}
Icon=/usr/lib/firefox/browser/icons/mozicon128.png
Terminal=FALSE" > /home/${REMOTE_USER_USERNAME}/Desktop/firefox_abn_link.desktop
chmod +x /home/${REMOTE_USER_USERNAME}/Desktop/firefox_abn_link.desktop



# alter the rstudio server so that it runs on port 80
echo -e "\n# alter the rstudio server so that it runs on port 80\n" >> /etc/rstudio/rserver.conf
echo -e "www-port=80\n" >> /etc/rstudio/rserver.conf
rstudio-server restart

# clone the workshop git repository so that the needed data are accessible
cd /home/${REMOTE_USER_USERNAME}/
git clone https://github.com/wall0159/R-workshop.git
cp /home/${REMOTE_USER_USERNAME}/R-workshop/plex_dat* /home/${REMOTE_USER_USERNAME}/


# Since this script is run as root, any files created by it are owned by root:root.
# Therefore, we'll ensure all files under /home/${REMOTE_USER_USERNAME} are owned
# by the correct user:
chown --recursive ${REMOTE_USER_USERNAME}:${REMOTE_USER_USERNAME} /home/${REMOTE_USER_USERNAME}/
