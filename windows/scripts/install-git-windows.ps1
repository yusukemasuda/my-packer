$GitURL = "https://github.com/git-for-windows/git/releases/download/v2.24.1.windows.2/Git-2.24.1.2-64-bit.exe"

function InstallGitWindows
{
  $exitCode = -1
  $FilePath = "${env:Temp}\git-for-windows-installer.exe"

  Write-Host "Downloading Git for Windows ..."
  if (Test-Path -Path "$FilePath")
  {
    Remove-Item -Path "$FilePath"
  }
  Invoke-WebRequest -Uri "$GitURL" -OutFile "$FilePath"

  Write-Host "Starting Install Git for Windows ..."
  $process = Start-Process -FilePath "`"$FilePath`"" -ArgumentList ("/SILENT") -Wait -PassThru
  $exitCode = $process.ExitCode

  if ($exitCode -eq 0)
  {
      Write-Host "Installed Git for Windows successfully." -ForegroundColor Cyan
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

$exitCode = InstallGitWindows

Write-Host -Object "Installation successful completed."
exit $exitCode
