$ErrorActionPreference = "Stop" # Stop to executing program when error is occured

##################################
# Check whether scripts are exist
##################################

# If even one file($data) does not exist, the script will stop executing.
$data = @('config.xlaunch', 'copy.ps1', 'copyfile.bat', 'do_not_turn_off.pow', 'imsautomount.sh', 'restore_power_settings.ps1', 'ubuntusoftwareinstall.sh', 'Update Anyconnect Adapter Interface Metric for WSL2.xml', 'UpdateAnyConnectInterfaceMetric.ps1', 'vscodeubuntusetup.sh', 'windowssetup.ps1', "writeubuntusettings.sh")
$data | ForEach-Object {
    if (!(Test-Path -Path $_ -PathType Leaf)) {
        Write-Host "Error: $_ is not exist."
        Write-Host "Exit."
        exit
    }
}
# Check windows version
$version = Get-WmiObject Win32_OperatingSystem | findstr "BuildNumber"
$winverlist = $version -split " +"
$winver = $winverlist[-1]

if ($winver -lt 18362){
    Write-Host "================================="
    Write-Host "ERROR: Your windows build version is $winver.`nWSL requires windows build version >= 18362.`nSo you must upgrade Windows OS at least build 18362(ver.1903).`nExit."
    Write-Host "================================="
    exit
}

# Enable wsl feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# Enable Virtual Machine platform feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart


######################################
# Power settings
######################################
New-Item -Path $Env:USERPROFILE\power_guid_default_setting -Force -ItemType Directory
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
    Write-Host "Make sure to manually configure or monitor Windows to prevent it from going to sleep"
    Write-Host "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
}
powercfg -list
$defaultsetting = -1
$defaultsetting = getGUID("*")
if ($defaultsetting -ne -1) {
    Write-Host "GUID of Default power setting is $defaultsetting"
    Set-Content "$Env:USERPROFILE\power_guid_default_setting\default_power_setting_guid.txt" $defaultsetting
    Copy-Item ".\do_not_turn_off.pow" "$Env:USERPROFILE\power_guid_default_setting"
    powercfg -import "$Env:USERPROFILE\power_guid_default_setting\do_not_turn_off.pow"
    Remove-Item "$Env:USERPROFILE\power_guid_default_setting\do_not_turn_off.pow"
    powercfg -list
    $do_not_turn_off = -1
    $do_not_turn_off = getGUID("do_not_turn_off")
    if ($do_not_turn_off -ne -1) {
        Write-Host "GUID of do_not_turn_off power setting is $do_not_turn_off"
        powercfg -setactive $do_not_turn_off
        Write-Host "do_not_turn_off power setting is activated!"
        powercfg -list
    }
    else {
        cantgetGUIDerr
    }
}
else {
    cantgetGUIDerr
}

######################################
# Disable cisco any connect only wsl2
######################################

# Create a task schedule for the task to disable vpn only for wsl2 related packets.
# See also : https://zenn.dev/hashiba/articles/wls2-on-cisco-anyconnect#%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%81%AE%E8%A8%AD%E5%AE%9A
New-Item -Path "$Env:USERPROFILE\scripts" -Force -ItemType Directory
Copy-Item '.\UpdateAnyConnectInterfaceMetric.ps1' "$Env:USERPROFILE\scripts"
schtasks /create /tn autoUpdatAnyconnectAdapterMetrixForWSL2 /xml '.\Update Anyconnect Adapter Interface Metric for WSL2.xml'

######################################
# Copy X-server settings
######################################

Copy-Item '.\config.xlaunch' "$Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
