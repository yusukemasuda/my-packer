function InstallDockerWindows() {
   $DockerURL = "https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
   $exitCode = -1
   $FilePath = "${env:Temp}\Docker Desktop Installer.exe"

   Write-Host "Downloading Docker Desktop for Windows ..."
   if (Test-Path -PathType Leaf -Path "$FilePath")
   {
       Remove-Item -Path "$FilePath"
   }
   Invoke-WebRequest -Uri "$DockerURL" -OutFile "$FilePath"
   $process = Start-Process -FilePath "`"$FilePath`"" -ArgumentList ("install", "--quiet") -Wait -PassThru
   $exitCode = $process.ExitCode
   if ($exitCode -eq 0)
   {
       Write-Host "Installed Docker Desktop for Windows successfully." -ForegroundColor Cyan
       return $exitCode
   }
   else
   {
       Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
       # this wont work because of log size limitation in extension manager
       # Get-Content $customLogFilePath | Write-Host
       exit $exitCode
   }
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$exitCode = InstallDockerWindows

Write-Host -Object "Installation successful"
exit $exitCode
