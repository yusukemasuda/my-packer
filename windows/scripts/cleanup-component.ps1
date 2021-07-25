
Write-Host "Starting Component Cleanup..." -ForegroundColor Cyan

$process = Start-Process -FilePath "`"${env:WINDIR}\SYSTEM32\Dism.exe`"" -ArgumentList ("/Online", "/Cleanup-Image", "/StartComponentCleanup", "/ResetBase") -Wait -PassThru
$exitCode = $process.ExitCode

if ($exitCode -eq 0)
{
    Write-Host "Finished Component Cleanup successfully." -ForegroundColor Cyan
    return $exitCode
}
else
{
    Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
    # this wont work because of log size limitation in extension manager
    # Get-Content $customLogFilePath | Write-Host
    exit $exitCode
}
