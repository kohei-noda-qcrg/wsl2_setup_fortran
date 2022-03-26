#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"

echo -e "============================="
echo -e "Start vscodeubuntusetup.sh"
echo -e "============================="

##############################
# Install VScode extensions
##############################

# WSL
code --install-extension ms-vscode-remote.vscode-remote-extensionpack --force

# Utils
code --install-extension formulahendry.code-runner --force
code --install-extension streetsidesoftware.code-spell-checker --force
code --install-extension timonwong.shellcheck --force
code --install-extension mads-hartmann.bash-ide-vscode --force
code --install-extension usernamehw.errorlens --force
code --install-extension PKief.material-icon-theme --force
code --install-extension IBM.output-colorizer --force
code --install-extension shardulm94.trailing-spaces --force
code --install-extension mosapride.zenkaku --force
code --install-extension sgryjp.japanese-word-handler --force
# C/C++ (required to install Modern Fortran extension)
code --install-extension ms-vscode.cpptools-extension-pack --force

# Fortran
code --install-extension ekibun.fortranbreaker --force
code --install-extension hansec.fortran-ls --force
code --install-extension krvajalm.linter-gfortran --force

# Git/Github
code --install-extension mhutchie.git-graph --force
code --install-extension donjayamanne.githistory --force
code --install-extension KnisterPeter.vscode-github --force
code --install-extension GitHub.vscode-pull-request-github --force
code --install-extension eamodio.gitlens --force
code --install-extension ms-vscode.hexeditor --force

# Markdonw
code --install-extension yzane.markdown-pdf --force
code --install-extension DavidAnson.vscode-markdownlint --force

##########################################
# Install vscode-server and launch VScode
##########################################
code .

# Create VScode setting file ( for WSL2 distribution virtual matchine )
mkdir -p "$HOME/.vscode-server/data/Machine"
which gfortran fortls | awk '{if(NR%2==1){print "{\n\t\"fortran.gfortranExecutable\":\t" "\""$1"\","}else{print "\t\"fortran-ls.executablePath\":\t" "\""$1"\",\n}"}}' > $HOME/.vscode-server/data/Machine/settings.json
echo -e "============================="
echo -e "End vscodeubuntusetup.sh"
echo -e "============================="
