#Requires -RunAsAdministrator
# Sets up the windows-forensics VM: clock, the Windows-only forensic tools, the host
# share, and Zed and Zen configured like on the host. Safe to run again, it only
# installs what is missing.

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$tools = 'C:\Tools'
# the host's editor and browser configuration, next to this script on the setup disc
$config = Join-Path $PSScriptRoot 'config'
$failed = @()

function Step($name, [scriptblock]$body) {
    Write-Host "==> $name"
    try { & $body } catch {
        Write-Warning "$name failed: $_"
        $script:failed += $name
    }
}

# Files copied off the disc arrive read-only, and both programs rewrite their own
function CopyConfig($from, $to) {
    New-Item -ItemType Directory -Force -Path $to | Out-Null
    Copy-Item (Join-Path $from '*') $to -Recurse -Force
    Get-ChildItem $to -Recurse -File | ForEach-Object { $_.IsReadOnly = $false }
}

Step 'Time zone' {
    # quickemu hands the guest the host's local time
    Set-TimeZone -Id 'GMT Standard Time'
}

Step 'Power' {
    # Windows does not come back from sleep on the virtual display, only a reset
    # of the VM recovers it
    powercfg /change standby-timeout-ac 0
    powercfg /change hibernate-timeout-ac 0
}

Step 'Tools folder' {
    New-Item -ItemType Directory -Force -Path $tools | Out-Null
    # Defender quarantines several NirSoft and credential-related tools on sight
    Add-MpPreference -ExclusionPath $tools
}

Step 'Chocolatey' {
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        $env:Path += ";$env:ProgramData\chocolatey\bin"
    }
}

$packages = @(
    'dotnet-9.0-desktopruntime' # runtime for the Zimmerman tools
    'winfsp' # file system layer the host share is mounted through
    'sysinternals'
    'arsenalimagemounter'
    'nirlauncher'
    'sqlitebrowser'
    'exiftool'
    '7zip'
    'notepadplusplus'
)
foreach ($package in $packages) {
    Step "choco: $package" {
        choco install $package --yes --no-progress --limit-output
        # 3010 means installed, reboot pending
        if ($LASTEXITCODE -notin 0, 3010) { throw "exit code $LASTEXITCODE" }
    }
}

Step 'Zimmerman tools' {
    $dest = Join-Path $tools 'EZTools'
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $script = Join-Path $dest 'Get-ZimmermanTools.ps1'
    Invoke-WebRequest -UseBasicParsing -OutFile $script `
        -Uri 'https://raw.githubusercontent.com/EricZimmerman/Get-ZimmermanTools/master/Get-ZimmermanTools.ps1'
    & $script -Dest $dest -NetVersion 9
}

Step 'Fonts' {
    $key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    foreach ($font in Get-ChildItem -LiteralPath (Join-Path $config 'fonts')) {
        Copy-Item -LiteralPath $font.FullName -Destination (Join-Path $env:WINDIR 'Fonts') -Force
        [Microsoft.Win32.Registry]::SetValue($key, "$($font.BaseName) (TrueType)", $font.Name)
    }
}

Step 'Zed' {
    # Chocolatey's zed package is an unrelated tool
    if (-not (Test-Path (Join-Path $env:LOCALAPPDATA 'Programs\Zed\Zed.exe'))) {
        $setup = Join-Path $env:TEMP 'Zed-x86_64.exe'
        Invoke-WebRequest -UseBasicParsing -OutFile $setup -Uri 'https://zed.dev/api/releases/stable/latest/Zed-x86_64.exe'
        Start-Process $setup -ArgumentList '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART' -Wait
    }
    CopyConfig (Join-Path $config 'zed') (Join-Path $env:APPDATA 'Zed')
}

Step 'Zen' {
    $program = Join-Path $env:ProgramFiles 'Zen Browser'
    if (-not (Test-Path (Join-Path $program 'zen.exe'))) {
        $setup = Join-Path $env:TEMP 'zen.installer.exe'
        Invoke-WebRequest -UseBasicParsing -OutFile $setup -Uri 'https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe'
        Start-Process $setup -ArgumentList '/S' -Wait
    }
    CopyConfig (Join-Path $config 'zen\program') $program
    CopyConfig (Join-Path $config 'zen\appdata') (Join-Path $env:APPDATA 'zen')
}

Step 'Host share' {
    # The driver comes with the virtio drivers, the service that mounts the share
    # as Z: only ships on the virtio-win disc
    if (-not (Get-Service VirtioFsSvc -ErrorAction SilentlyContinue)) {
        $disc = Get-Volume | Where-Object { $_.DriveLetter -and (Test-Path "$($_.DriveLetter):\viofs\w11\amd64\virtiofs.exe") } |
            Select-Object -First 1
        if (-not $disc) { throw 'virtio-win disc not found' }
        $dir = Join-Path $env:ProgramFiles 'VirtIO-FS'
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Copy-Item "$($disc.DriveLetter):\viofs\w11\amd64\virtiofs.exe" $dir -Force
        New-Service -Name VirtioFsSvc -DisplayName 'VirtIO-FS Service' -StartupType Automatic `
            -BinaryPathName "`"$dir\virtiofs.exe`"" -DependsOn 'WinFsp.Launcher' | Out-Null
    }
    Start-Service VirtioFsSvc
}

Step 'Display auto-resize' {
    # The GPU driver alone keeps a fixed resolution, following the viewer window
    # is done by a service that only ships on the virtio-win disc
    if (-not (Get-Service vgpusrv -ErrorAction SilentlyContinue)) {
        $src = Get-Volume | Where-Object DriveLetter | ForEach-Object { "$($_.DriveLetter):\viogpudo\w11\amd64" } |
            Where-Object { Test-Path "$_\vgpusrv.exe" } | Select-Object -First 1
        if (-not $src) { throw 'virtio-win disc not found' }
        $dir = Join-Path $env:ProgramFiles 'VirtIO-GPU'
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
        Copy-Item "$src\vgpusrv.exe", "$src\viogpuap.exe" $dir -Force
        & "$dir\vgpusrv.exe" -i | Out-Null
    }
}

Step 'Remote Desktop' {
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' fDenyTSConnections 0
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
}

Step 'Appearance' {
    # Per user, so this applies to whoever runs the script, from the next sign-in
    $personalize = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    New-Item -Force -Path $personalize | Out-Null
    Set-ItemProperty $personalize AppsUseLightTheme 0
    Set-ItemProperty $personalize SystemUsesLightTheme 0
    # nothing accelerates the guest's graphics, so every effect is drawn on the CPU
    Set-ItemProperty $personalize EnableTransparency 0
    $effects = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
    New-Item -Force -Path $effects | Out-Null
    Set-ItemProperty $effects VisualFXSetting 3
    Set-ItemProperty 'HKCU:\Control Panel\Desktop' UserPreferencesMask ([byte[]](0x90, 0x12, 0x03, 0x80, 0x10, 0x00, 0x00, 0x00))
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' MinAnimate '0'
    Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' TaskbarAnimations 0

    Set-ItemProperty 'HKCU:\Control Panel\Colors' Background '0 0 0'
    Set-ItemProperty 'HKCU:\Control Panel\Desktop' Wallpaper ''
}

Step 'Command line tools on PATH' {
    $ez = Join-Path $tools 'EZTools\net9'
    $wanted = @($ez) + (Get-ChildItem $ez -Directory | Where-Object Name -Match 'Cmd$' | ForEach-Object FullName)
    $path = [Environment]::GetEnvironmentVariable('Path', 'Machine').TrimEnd(';').Split(';')
    $missing = $wanted | Where-Object { $_ -notin $path }
    if ($missing) {
        [Environment]::SetEnvironmentVariable('Path', (($path + $missing) -join ';'), 'Machine')
    }
}

Step 'Shortcuts' {
    # Most of these tools are plain executables that register nothing in the Start menu
    $menu = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Forensics'
    New-Item -ItemType Directory -Force -Path $menu | Out-Null
    $shell = New-Object -ComObject WScript.Shell

    function Link($name, $target, $arguments = '', $dir = (Split-Path $target), $folder = $menu) {
        $link = $shell.CreateShortcut((Join-Path $folder "$name.lnk"))
        $link.TargetPath = $target
        $link.Arguments = $arguments
        $link.WorkingDirectory = $dir
        $link.Save()
    }

    $choco = Join-Path $env:ProgramData 'chocolatey\lib'
    $gui = @(Get-ChildItem (Join-Path $tools 'EZTools\net9') -Recurse -Filter *.exe |
            Where-Object Name -Match '(Explorer|Viewer)\.exe$')
    $gui += Get-ChildItem (Join-Path $choco 'arsenalimagemounter\tools\*\ArsenalImageMounter.exe')
    $gui += Get-ChildItem (Join-Path $tools 'NirLauncher\NirLauncher.exe')
    $gui += Get-ChildItem (Join-Path $choco 'sysinternals\tools\*') -Include procexp64.exe, Procmon64.exe, Autoruns64.exe, tcpview64.exe
    foreach ($exe in $gui) { Link $exe.BaseName $exe.FullName }

    $powershell = Join-Path $PSHOME 'powershell.exe'
    Link 'EZ Tools command line' $powershell '-NoExit -Command "Get-ChildItem -Recurse -Filter *.exe -Name"' (Join-Path $tools 'EZTools\net9')
    Link 'Forensic Tools' $menu -dir $menu -folder (Join-Path $env:PUBLIC 'Desktop')
}

Write-Host ''
Write-Host 'Not installable unattended, their downloads sit behind a form:'
Write-Host '  KAPE         https://www.kroll.com/kape'
Write-Host '  FTK Imager   https://www.exterro.com/digital-forensics-software/ftk-imager'
Write-Host "Unpack them under $tools."

if ($failed) {
    Write-Warning ("Failed steps: " + ($failed -join ', '))
    exit 1
}
Write-Host 'All steps completed.'
