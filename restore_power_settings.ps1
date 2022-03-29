$ErrorActionPreference = "Stop" # Stop to executing program when error is occured

Function getGUID($arg="*"){
    $flag=0 # If GUID: found, $flag = 1
    $guid="" # When $flag is 1, get the value of $var divided at that time and set $flag to 0

    # Get powercfg settings text including $arg
    $text= powercfg -list | findstr $arg
    # Split $text
    $split=$text -split " "
    foreach($var in $split){
        # Set $guid to $var when $flag = 1
        if($flag -eq 1){
            $guid=$var
            $flag=0
        }
        # If $var="GUID:", set $flag to 1
        if($var -eq "GUID:"){
            $flag=1
        }
    }
    if( $guid -eq ""){
        # Error
        Write-Host "GUID is empty"
        return -1
    }else{
        Write-Host "Found GUID"
        return $guid
    }
}
Function cantgetGUIDerr(){
    # Quit powercfg setting
    Write-Host "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
    Write-Host "<ERROR: powercfg settings GUID obtain error>"
    Write-Host "Powercfg setting was stopped because GUID could not be obtained."
    Write-Host "Make sure to manually configure to the default power setting."
    Write-Host '"Balance" is recommended.'
    Write-Host "!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!=!="
}

$defaultsetting=-1
$defaultsetting= Get-Content "$Env:USERPROFILE\power_guid_default_setting\default_power_setting_guid.txt"
Write-Host "defaultsetting is "$defaultsetting
if ($defaultsetting -ne -1){
    powercfg -setactive $defaultsetting
    Write-Host "default power setting is  reactivated!"
    powercfg -list
}else{
cantgetGUIDerr
}
