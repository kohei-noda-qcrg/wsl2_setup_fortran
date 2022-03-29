$ErrorActionPreference = "Stop" # Stop to executing program when error is occured

# Enable wsl feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# Enable Virtual Machine platform feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
