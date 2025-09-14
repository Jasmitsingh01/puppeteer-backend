# PowerShell script to prepare Chrome profile for Docker

# Create profile-data directory if it doesn't exist
$profileDataDir = "./profile-data"
if (-not (Test-Path $profileDataDir)) {
    New-Item -ItemType Directory -Path $profileDataDir -Force
}

# Essential Chrome profile directories to copy
$essentialDirs = @(
    "Preferences",
    "First Run",
    "Last Version",
    "Local State",
    "Bookmarks",
    "Cookies",
    "History",
    "Login Data",
    "Favicons",
    "Web Data",
    "Extension Cookies",
    "Extension State"
)

# Source profile directory
$sourceDir = "./my-profile"

# Copy essential files and directories
foreach ($item in $essentialDirs) {
    $sourcePath = Join-Path $sourceDir $item
    $destPath = Join-Path $profileDataDir $item
    
    if (Test-Path $sourcePath) {
        if (Test-Path -PathType Container $sourcePath) {
            # It's a directory
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
        } else {
            # It's a file
            Copy-Item -Path $sourcePath -Destination $destPath -Force
        }
        Write-Host "Copied: $item"
    }
}

Write-Host "Profile preparation complete. Essential files copied to $profileDataDir"