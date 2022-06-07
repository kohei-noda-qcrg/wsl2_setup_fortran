#!/bin/bash
set -euo pipefail # Abort script when error is occured.
cd "$(dirname "$0")"

echo -e "============================="
echo -e "Start vscodeubuntusetup.sh"
echo -e "============================="

##############################
# Install VScode extensions
##############################

# WSL and Remote-ssh and Remote-containers support
code --install-extension ms-vscode-remote.vscode-remote-extensionpack --force

# Utils
code --install-extension formulahendry.code-runner --force # Execute script extension
code --install-extension streetsidesoftware.code-spell-checker --force # check English Spell
code --install-extension timonwong.shellcheck --force # Powerful support for syntax error of shell scripts
code --install-extension mads-hartmann.bash-ide-vscode --force # Powerful support for bash script
code --install-extension usernamehw.errorlens --force # Whether or not you hover over the error line, highlight errors
code --install-extension PKief.material-icon-theme --force # Change Vscode explorer icons
code --install-extension IBM.output-colorizer --force # Colorize output file
code --install-extension shardulm94.trailing-spaces --force # Detect end of line spaces and highlight these
code --install-extension mosapride.zenkaku --force # Detect Zenkaku characters and highlight these
code --install-extension sgryjp.japanese-word-handler --force # Japanese word jump extension
code --install-extension ms-vscode.hexeditor --force # Binary viewer
code --install-extension EditorConfig.EditorConfig --force # Force code rules

# C/C++ (required to install Modern Fortran extension)
code --install-extension ms-vscode.cpptools-extension-pack --force

# Fortran
code --install-extension ekibun.fortranbreaker --force # Fortran breakpoint support
code --install-extension fortran-lang.linter-gfortran --force # Fortran linter, formatter, syntax highlight

# Git/Github
code --install-extension mhutchie.git-graph --force # View git history as a graphical tree
code --install-extension donjayamanne.githistory --force # Add convenient features to Vscode Source control tab
code --install-extension KnisterPeter.vscode-github --force # Support for github
code --install-extension GitHub.vscode-pull-request-github --force # Support for github pull requests and issues
code --install-extension eamodio.gitlens --force # Visualize code authorship and so on

# Markdown
code --install-extension yzane.markdown-pdf --force # Convert Markdown to pdf
code --install-extension DavidAnson.vscode-markdownlint --force # Markdown linter

##########################################
# Install vscode-server and launch VScode
##########################################
code .

# Create VScode setting file ( for WSL2 distribution virtual matchine )
mkdir -p "$HOME/.vscode-server/data/Machine"
settingfilepath="$HOME/.vscode-server/data/Machine/settings.json"
if [ -e settingfilepath ]; then
 cp "$settingfilepath" "$HOME/.vscode-server/data/Machine/settings.json.bak"
fi
# Check fortls exsists
fortlspath=$(command -v fortls)
if [ "$fortlspath" ]; then
    fortls=${fortlspath}
else
    fortls=${HOME}/.local/bin/fortls
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
    print "!!! Warning !!!"
    print "foltls is not installed on your machine.\nYou should install fortls manually with the following command.\npip install fortls"
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
fi

# Write settings.json for Modern Fortran developers
echo -e "{\n\t\"fortran.linter.compiler\":\t\"gfortran\",\n\t\"fortran.formatting.fprettifyArgs\": [\"-i 4\"],\n\t\"fortran.formatting.formatter\": \"fprettify\",\n\t\"fortran.fortls.path\":\t\"${fortls}\",\n}" > "$settingfilepath"

# Check gfortran exsists
gfortranpath=$(command -v gfortran)
if [ ! "$gfortranpath" ]; then
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
    print "!!! Warning !!!"
    print "gfortran is not installed on your machine.\nYou should install gfortran manually with the following command.\nsudo apt install gfortran"
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
fi
# Check gfortran exsists
fprettifypath=$(command -v fprettify)
if [ ! "$fprettifypath" ]; then
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
    print "!!! Warning !!!"
    print "fprettify is not installed on your machine.\nYou should install fprettify manually with the following command.\npip install fprettify"
    print "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
fi

echo -e "============================="
echo -e "End vscodeubuntusetup.sh"
echo -e "============================="
