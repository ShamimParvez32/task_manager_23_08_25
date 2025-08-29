# rename_apk.ps1
# Path to your Flutter project
$projectPath = "D:\flutter\flutter\my_projects\task_manager_23_08_25"

# APK folder and file
$apkFolder = Join-Path $projectPath "build\app\outputs\flutter-apk"
$apkFile = Join-Path $apkFolder "app-release.apk"

# Read version info from pubspec.yaml
$pubspec = Get-Content (Join-Path $projectPath "pubspec.yaml") -Raw
$versionLine = ($pubspec -split "`n" | Where-Object { $_ -match "^version:" })[0]
$version = ($versionLine -split " ")[1]  # e.g., "1.0.0+1"

# Build new APK name
$appName = "TaskManager"
$newName = "${appName}_v$version_release.apk"
$newPath = Join-Path $apkFolder $newName

# Rename file
if (Test-Path $apkFile) {
    Rename-Item $apkFile $newPath -Force
    Write-Host "APK renamed to $newName"
} else {
    Write-Host "APK file not found!"
}
