# Stops the services started by start-backend.ps1 (leaves Docker containers running).
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Get-ChildItem "$here\logs\*.pid" -ErrorAction SilentlyContinue | ForEach-Object {
    $svcPid = Get-Content $_
    try { Stop-Process -Id $svcPid -Force -ErrorAction Stop; Write-Host "Stopped $($_.BaseName) (pid $svcPid)" }
    catch { Write-Host "$($_.BaseName) was not running" }
    Remove-Item $_
}
