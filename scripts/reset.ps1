Function getGUID($arg = "*") {
    $flag = 0 # If GUID: found, $flag = 1
    $guid = "" # When $flag is 1, get the value of $var divided at that time and set $flag to 0

    # Get powercfg settings text including $arg
    $text = powercfg -list | findstr $arg
    # Split $text
    $split = $text -split " "
    foreach ($var in $split) {
        # Set $guid to $var when $flag = 1
        if ($flag -eq 1) {
            $guid = $var
            $flag = 0
        }
        # If $var="GUID:", set $flag to 1
        if ($var -eq "GUID:") {
            $flag = 1
        }
    }
    if ( $guid -eq "") {
        # Error
        Write-Host "GUID is empty"
        return -1
    }
    else {
        Write-Host "Found GUID"
        return $guid
    }
}
Function cantgetGUIDerr() {
    # Quit powercfg setting
    Write-Host "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
    Write-Host "<ERROR: powercfg settings GUID obtain error>"
    Write-Host "Powercfg setting was stopped because GUID could not be obtained."
    Write-Host "Make sure to manually configure to the default power setting."
    Write-Host '"Balance" is recommended.'
    Write-Host "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
}

$defaultsetting = Get-Content "$Env:USERPROFILE\power_guid_default_setting\default_power_setting_guid.txt"
Write-Host "defaultsetting is $defaultsetting"
if ($defaultsetting -ne "") {
    powercfg -setactive $defaultsetting
    Write-Host "default power setting is reactivated!"
    powercfg -list
}
else {
    cantgetGUIDerr
}
$count = 0
$do_not_turn_off = getGUID("do_not_turn_off")
while (($do_not_turn_off -ne -1) -and ($count -lt 10)){
    powercfg /delete $do_not_turn_off
    Write-Host "GUID:$do_not_turn_off power setting is deleted!"
    $do_not_turn_off = getGUID("do_not_turn_off")
    $count = $count + 1
}
powercfg -list

# Remove power_guid_default_setting folder
Remove-Item -Recurse -Force "$Env:USERPROFILE\power_guid_default_setting"
Remove-Item "$Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startupconfig.xlaunch"
Unregister-ScheduledTask -TaskName autoUpdatAnyconnectAdapterMetrixForWSL2 -Confirm:$false

wsl --unregister Ubuntu

# WindowsTerminal (https://www.microsoft.com/ja-jp/p/windows-terminal/9n0dx20hk701)
# is a powerful terminal software. I recommend you to use this software when you use WSL2 ubuntu.
winget uninstall --silent Microsoft.WindowsTerminal --accept-source-agreements

# Vscode (https://code.visualstudio.com/)
# is a very powerful editor. I strongly suggest you to use this editor when you edit any text files.
# (Install option reference is here : https://proudust.github.io/20200726-winget-install-vscode/)
winget uninstall --silent Microsoft.VisualStudioCode

# You can extract tar.gz etc. files by using 7zip (https://sevenzip.osdn.jp/).
winget uninstall --silent 7zip.7zip

# Winscp (https://winscp.net/eng/docs/lang:jp)
# provides you to download/upload files with calculation servers by using scp (or sftp) protocol.
winget uninstall --silent WinSCP.WinSCP

# Git (https://gitforwindows.org/) supports git command on windows.
winget uninstall --silent Git.Git

# Teraterm (https://ttssh2.osdn.jp/) is a terminal software.
# If you don't like other terminal softwares, you can use this software.
#winget uninstall --silent TeraTermProject.teraterm --accept-source-agreements

# VcXsrv (https://sourceforge.net/projects/vcxsrv/) is a X-server software.
# If you want to use GUI software when you use CLI WSL linux, VcXsrv supports this(GUI) feature.
#winget uninstall --silent marha.VcXsrv
