#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"

echo -e "============================="
echo -e "Start writeubuntusettings.sh"
echo -e "============================="
# Manually update DNS server settings
sudo sh -c 'echo "[network]\ngenerateResolvConf = false" > /etc/wsl.conf'
if [ -e /etc/resolv.conf ]; then
	sudo mv /etc/resolv.conf /etc/resolv.conf.old
fi
sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo chattr +i /etc/resolv.conf

echo -e "DNS server settings successed"

# Enable WSL2 to change permissions on Windows files.
sudo sh -c 'echo "[automount]\noptions = \"metadata\"" >> /etc/wsl.conf'

# Allow specify other users when using sshfs
sudo sh -c 'echo user_allow_other >> /etc/fuse.conf'
echo -e "SFTP setting successed"

# X11 display IP setting
echo -e "export DISPLAY=\$(ipconfig.exe | grep \"IPv4\" | head -1 | awk '{print \$NF}' | awk 'sub(/\r\$/,\"\")'):0" >> "$HOME/.profile"
echo -e "Xserver DISPLAY setting successed"

# Add pip path
echo "export PATH=\$PATH:$HOME/.local/bin" >> "$HOME/.bashrc"
echo -e "Added pip path to ~/.bashrc"

# Create ssh config template
mkdir -p "$HOME/.ssh"
echo -e "#This is .ssh/config tempalate for the relqc server.You can use this template by editing the part of enclosed in {}.\n\nServerAliveInterval 60\nServerAliveCountMax 10\n\nHost ims\n\tHostName ccfep.center.ims.ac.jp\n\tUser {YOURNAME}\n\tIdentityfile {YOUR_SECRET_KEY_PATH}\n\tPasswordAuthentication no\n\tTCPKeepAlive yes" > "$HOME/.ssh/config"
echo -e "Added ssh config to ~/.ssh/config"

# Locale settings
# See also : https://askubuntu.com/questions/683406/how-to-automate-dpkg-reconfigure-locales-with-one-command
sudo echo "locales locales/default_environment_locale select en_US.UTF-8" | sudo debconf-set-selections
sudo echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | sudo debconf-set-selections
sudo rm "/etc/locale.gen"
sudo dpkg-reconfigure --frontend noninteractive locales
echo -e "Changed locale to en_US.UTF8."

echo -e "============================="
echo -e "WSL2 ubuntu setting write script ended.\nNext, you need to run ubuntusoftwareinstall.sh.\nTo run this script, Type $HOME/ubuntusoftwareinstall.sh"
echo -e "============================="
