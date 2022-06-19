#########################
# Install wsl (Ubuntu)
#########################
Function ManuallyInstallWSL2() {
    # Set default WSL version to 2
    wsl --set-default-version 2
    # Install Ubuntu
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu -OutFile linux.appx -UseBasicParsing
    Add-AppxPackage -Path linux.appx
    Remove-Item linux.appx
}

# WSL 2 Kernel Update
Write-Host "Start downloading a wsl2 kernel update file"
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing
Write-Host "Downloaded a wsl2 kernel update file"
msiexec /i wsl_update_x64.msi /passive /norestart
Write-Host "Applied a wsl2 kernel update file"

# Check if wsl command is recognized on your computer (KB5004296 is required)
# See also : https://forest.watch.impress.co.jp/docs/news/1342078.html
$wslcommand = "wsl"
# Check windows version
$version = Get-WmiObject Win32_OperatingSystem | findstr "BuildNumber" # (e.g.) BuildNumber : 19041
$winverlist = $version -split " +"
$winver = $winverlist[-1] # (e.g.) 19041
if ($winver -lt 18362){ # Cannot use wsl under 18362
    Write-Host "================================="
    Write-Host "ERROR: Your windows build version is $winver.`nWSL requires windows build version >= 18362.1049+.`nSo you must upgrade Windows OS at least build 18362(ver.1903).`nIf you want more information, see https://docs.microsoft.com/ja-jp/windows/wsl/install-manual.`nExit."
    Write-Host "================================="
    exit
}elseif ($winver -eq 18362){ # 18362 is Version 1903 https://docs.microsoft.com/ja-jp/windows/release-health/release-information
    Write-Host "================================="
    Write-Host "Warning: Your windows build version is $winver.`nwsl --install command requires windows build version >= 19041.`nTo get Ubuntu, run manually install commands.`nAfter install Ubuntu you must launch Ubuntu on your own."
    Write-Host "================================="
    ManuallyInstallWSL2
}elseif ($winver -eq 18363){ # 18363 is Version 1909 https://docs.microsoft.com/ja-jp/windows/release-health/release-information
    Write-Host "================================="
    Write-Host "Warning: Your windows build version is $winver.`nwsl --install command requires windows build version >= 19041.`nTo get Ubuntu, run manually install commands.`nAfter install Ubuntu you must launch Ubuntu on your own."
    Write-Host "================================="
    ManuallyInstallWSL2
}
elseif ($winver -lt 19041){ # Cannot use wsl --install command under 19041 https://docs.microsoft.com/ja-jp/windows/wsl/install-manual
    Write-Host "================================="
    Write-Host "Warning: Your windows build version is $winver.`nwsl --install command requires windows build version >= 19041.`nTo get Ubuntu, run manually install commands.`nAfter install Ubuntu you must launch Ubuntu on your own."
    Write-Host "================================="
    ManuallyInstallWSL2
}else{ # Can use wsl --install command >= 19041 https://docs.microsoft.com/ja-jp/windows/wsl/install-manual
    try {
        if (Get-Command $wslcommand) {
            Write-Host "$wslcommand exists! try to install Ubuntu using $wslcommand command."
            wsl --install
            wsl --set-default-version 2
            wsl --install -d Ubuntu
            wsl --set-default Ubuntu
        }
        else {
            Write-Host "$command does not exist. To use $command command, Install dependencies."
            ManuallyInstallWSL2
        }
    }
    catch {
        Write-Host "catch err."
        ManuallyInstallWSL2
    }
}


##############################
# winget setup
##############################
# If you don't have winget, Manually install winget on $Env:Temp Folder.
# See also : https://zenn.dev/nobokko/articles/idea_winget_wsb#windows%E3%82%B5%E3%83%B3%E3%83%89%E3%83%9C%E3%83%83%E3%82%AF%E3%82%B9%E3%81%ABwinget%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%97%E3%82%88%E3%81%86%EF%BC%81%E3%81%A8%E3%81%84%E3%81%86%E8%A9%B1
$winget = "winget"
if ( -not ( Get-Command $winget -ErrorAction "silentlycontinue" ) ) {
    Write-Host "winget command does not exist.`n Try to install winget manually using invoke-webrequest and Add-AppxPackage!"
    invoke-webrequest -uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -outfile $Env:Temp\Microsoft.VCLibs.x64.14.00.Desktop.appx -UseBasicParsing
    invoke-webrequest -uri https://github.com/microsoft/winget-cli/releases/download/v1.0.12576/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -outfile $Env:Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -UseBasicParsing
    Add-AppxPackage -Path $Env:Temp\Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage -Path $Env:Temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
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
winget install --silent --scope user WinSCP.WinSCP

# Git (https://gitforwindows.org/) supports git command on windows.
winget install --silent Git.Git

# Teraterm (https://ttssh2.osdn.jp/) is a terminal software.
# If you don't like other terminal softwares, you can use this software.
winget install --silent TeraTermProject.teraterm --override "/VERYSILENT"

# VcXsrv (https://sourceforge.net/projects/vcxsrv/) is a X-server software.
# If you want to use GUI software when you use CLI WSL linux, VcXsrv supports this(GUI) feature.
winget install --silent marha.VcXsrv
