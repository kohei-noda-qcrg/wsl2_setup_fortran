#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"
ok=abcdefghijklmnopqstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
getinput(){
    read -p "Type your username of ccfep.center.ims.ac.jp :" username
    checkinput
}
checkinput(){
    case $username in
        ("") echo -e "Username can't be empty.\nPlease type your username again.\n" && getinput;;
        (*[!$ok]*) echo -e "contains non-alphabetical or numerical characters.\nPlease type your username again.\n" && getinput;;
        (*) echo OK
    esac
}

getinput
echo "$username"
# Create $HOME/$username directory
mkdir -p "$HOME/$username"
# Add alias command to mount ccfep.center.ims.ac.jp:/home/users/$username
echo "alias mount='sshfs -o uid=\`id -u\` -o gid=\`id -g\` -o allow_other -o nonempty ims:/home/users/$username \$HOME/$username'" >> "$HOME/.profile"
# Add automount ccfep.center.ims.ac.jp:/home/users/$username script when you launch Ubuntu.
echo -e "if [ \"\$(ls \$HOME/$username)\" ]; then\n\techo \"\$HOME/$username is not empty.\"\nelse\n\tmount\nfi" >> "$HOME/.profile"
# Add alias command to mount ccfep.center.ims.ac.jp:/home/users/$username
echo "alias imsumount='sudo umount -f \$HOME/$username'" >> "$HOME/.profile"
