$ErrorActionPreference = "Stop" # Stop to executing program when error is occured

##################################
# Check whether scripts are exist
##################################

# If even one file($data) does not exist, the script will stop executing.
$data = @('config.xlaunch', 'Update Anyconnect Adapter Interface Metric for WSL2.xml', 'UpdateAnyConnectInterfaceMetric.ps1', 'vscodeubuntusetup.sh', 'ubuntusoftwareinstall.sh', 'imsautomount.sh', 'copy.ps1', 'copyfile.bat')
$data | ForEach-Object {
    if (!(Test-Path -Path $_ -PathType Leaf)) {
        Write-Host "Error: $_ is not exist."
        Write-Host "Exit."
        exit
    }
}

######################################
# Disable cisco any connect only wsl2
######################################

# Create a task schedule for the task to disable vpn only for wsl2 related packets.
# See also : https://zenn.dev/hashiba/articles/wls2-on-cisco-anyconnect#%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%81%AE%E8%A8%AD%E5%AE%9A
New-Item -Path $Env:USERPROFILE\scripts -Force -ItemType Directory
Copy-Item '.\UpdateAnyConnectInterfaceMetric.ps1' $Env:USERPROFILE\scripts
schtasks /create /tn autoUpdatAnyconnectAdapterMetrixForWSL2 /xml '.\Update Anyconnect Adapter Interface Metric for WSL2.xml'

#########################
# Install wsl (Ubuntu)
#########################
$wslpath = "C:\Windows\System32\wsl.exe"
if ( -not (Test-Path $wslpath)) {
    invoke-webrequest -uri https://github.com/microsoft/WSL/releases/download/0.56.2/Microsoft.WSL_0.56.2.0_x64_ARM64.msixbundle -outfile $Env:USERPROFILE\Downloads\Microsoft.WSL_0.56.2.0_x64_ARM64.msixbundle -UseBasicParsing
    Add-AppxPackage -Path $Env:USERPROFILE\Downloads\Microsoft.WSL_0.56.2.0_x64_ARM64.msixbundle
}
wsl --install
wsl --set-default-version 2
wsl --install -d Ubuntu
wsl --set-default Ubuntu

##############################
# winget setup
##############################
# If you don't have winget, Manually install winget on $Env:USERPROFILE\Downloads Folder.
# See also : https://zenn.dev/nobokko/articles/idea_winget_wsb#windows%E3%82%B5%E3%83%B3%E3%83%89%E3%83%9C%E3%83%83%E3%82%AF%E3%82%B9%E3%81%ABwinget%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%97%E3%82%88%E3%81%86%EF%BC%81%E3%81%A8%E3%81%84%E3%81%86%E8%A9%B1
$wingetpath = "$Env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\winget.exe"
if ( -not ( Test-Path $wingetpath) ) {
    invoke-webrequest -uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -outfile $Env:USERPROFILE\Downloads\Microsoft.VCLibs.x64.14.00.Desktop.appx -UseBasicParsing
    invoke-webrequest -uri https://github.com/microsoft/winget-cli/releases/download/v1.0.12576/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -outfile $Env:USERPROFILE\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -UseBasicParsing
    Add-AppxPackage -Path $Env:USERPROFILE\Downloads\Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage -Path $Env:USERPROFILE\Downloads\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

##############################
# Install softwares (windows)
##############################

# WindowsTerminal (https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701)
# is a powerful terminal software. I recommend you to use this software when you use WSL2 ubuntu.
winget install --silent Microsoft.WindowsTerminal --accept-package-agreements --accept-source-agreements

# Vscode (https://code.visualstudio.com/)
# is a very powerful editor. I strongly suggest you to use this editor when you edit any text files.
# (Install option reference is here : https://proudust.github.io/20200726-winget-install-vscode/)
winget install --silent Microsoft.VisualStudioCode --override "/VERYSILENT /NORESTART /mergetasks=""!runcode,desktopicon,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath"""

# You can extract tar.gz etc. files by using 7zip (https://sevenzip.osdn.jp/).
winget install --silent 7zip.7zip

# Winscp (https://winscp.net/eng/docs/lang:jp)
# provides you to download/upload files with calculation servers by using scp (or sftp) protocol.
winget install --silent --scope user winscp

# Git (https://gitforwindows.org/) supports git command on windows.
winget install --silent Git.Git

# Teraterm (https://ttssh2.osdn.jp/) is a terminal software.
# If you don't like other terminal softwares, you can use this software.
winget install --silent TeraTerm --override "/VERYSILENT"

# VcXsrv (https://sourceforge.net/projects/vcxsrv/) is a X-server software.
# If you want to use GUI software when you use CLI WSL linux, VcXsrv supports this(GUI) feature.
winget install --silent VcXsrv
Copy-Item '.\config.xlaunch' "$Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
