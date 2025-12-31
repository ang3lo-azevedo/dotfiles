Write-Host "Starting Windows Bootstrap..." -ForegroundColor Cyan

# Elevate Privilege Level
Set-ExecutionPolicy Bypass -Scope Process -Force

# Network Wait (Wait for Wi-Fi/Ethernet to actually initialize)
Write-Host "Waiting for internet connection..."
while (!(Test-Connection -ComputerName 1.1.1.1 -Count 1 -ErrorAction SilentlyContinue)) { 
    Start-Sleep -Seconds 2 
}

# Install Winget (If not present in LTSC)
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Winget Package Manager..."
    $AppInstallerUrl = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Invoke-WebRequest -Uri $AppInstallerUrl -OutFile "$env:TEMP\winget.msixbundle"
    Add-AppxPackage "$env:TEMP\winget.msixbundle"
}

# Essential Drivers & Frameworks
Write-Host "Installing Core Runtimes and Drivers..."
$apps = @(
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.DotNet.DesktopRuntime.8",
    "Git.Git" # Needed for Ansible/Repo pulling
)
foreach ($app in $apps) { winget install --id $app --silent --accept-package-agreements --accept-source-agreements }

# Enable WinRM (Crucial for Ansible control)
Write-Host "Configuring WinRM for Ansible..."
winrm quickconfig -quiet
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
New-NetFirewallRule -Name "WinRM_5985" -DisplayName "Allow WinRM 5985" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 5985

Write-Host "Bootstrap Complete. System is ready for Ansible Playbook." -ForegroundColor Green