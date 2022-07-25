#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"

echo -e "============================="
echo -e "Start ubuntusoftwareinstall.sh"
echo -e "============================="

# Update packages
sudo dpkg --configure -a
sudo apt-get update
sudo apt-get -y autoremove

# Upgrade the packages to latest version
sudo apt-get -y full-upgrade

# Install build-essential (gcc etc.)
sudo apt-get install -y build-essential

# Install dependencies
sudo apt-get install -y libbz2-dev libdb-dev libreadline-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev libsqlite3-dev libssl-dev zlib1g-dev uuid-dev libffi-dev

# Install ssh relation packages
sudo apt-get install -y sshfs

# Install pip and python
sudo apt-get install -y python3-pip python3-dev python-is-python3

# Install gfortran for VScode debugging
sudo apt-get install -y gfortran

# Update pip
python -m pip install -U pip --no-warn-script-location

# Install python packages for numerical calculation
python -m pip install numpy scipy pandas matplotlib --no-warn-script-location

# Install fortran-language-server for VScode extention (Fortran Intellisense)
python -m pip install fortls fprettify pytest --no-warn-script-location

echo -e "============================="
echo -e "WSL2 ubuntu setup script ended. Please restart WSL2.\n1. Open powershell\n2. Type \" wsl --shutdown \"\n3. Restart Ubuntu"
echo -e "============================="
