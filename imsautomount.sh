#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"

# 
mkdir -p $HOME/sm2
echo "alias mount='sshfs -o uid=\`id -u\` -o gid=\`id -g\` -o allow_other ims:/home/users/sm2 $HOME/sm2'" >> $HOME/.profile
echo -e 'if [ $(ls -A $HOME/sm2) ]; then\n\techo "$HOME/sm2 is not empty."\nelse\n\tmount\nfi' >> $HOME/.profile
