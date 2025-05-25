# Winget Auto-Install Script with Administrative Privileges

# Function to ensure the script is running as Administrator
function Ensure-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Output "Restarting script with administrative privileges..."
        Start-Process -FilePath "powershell.exe" -ArgumentList ("-NoProfile", "-ExecutionPolicy Bypass", "-File", "$PSCommandPath") -Verb RunAs
        exit
    }
}

# Ensure the script is running with administrative privileges
Ensure-Admin

# Function for colored output
function Write-Success { param([string]$msg) Write-Host $msg -ForegroundColor Green }
function Write-Failure { param([string]$msg) Write-Host $msg -ForegroundColor Red }

# Ensure the script is running with administrative privileges
Ensure-Admin

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Failure "Winget is not installed. Please install App Installer from Microsoft Store."
    exit 1
}

# Start logging
$logFile = "$env:USERPROFILE\winget_install_log.txt"
Start-Transcript -Path $logFile -Append

# List of applications to install
$applications = @(
    "7zip.7zip",
    "CrystalDewWorld.CrystalDiskInfo",
    "Git.Git",
    "Mozilla.Firefox",
    "Notepad++.Notepad++",
    "Google.Chrome",
    "Cyanfish.NAPS2",
    "Starship.Starship",
    "Microsoft.Edge",
    "qBittorrent.qBittorrent",
    "Foxit.FoxitReader"
)

# Install each application
foreach ($app in $applications) {
    try {
        Write-Host "`nInstalling $app..."
        winget install --id=$app --accept-source-agreements --accept-package-agreements -e -h
        Write-Success "$app installed successfully."
    } catch {
        Write-Failure "Failed to install $app. Error: $_"
    }
}

# Stop logging
Stop-Transcript
