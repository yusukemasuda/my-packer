function InstallJenkins
{
  $JenkinsURL = "http://mirrors.jenkins.io/windows/latest"
  $exitCode = -1

  $ZipFilePath = "${env:Temp}\Jenkins.zip"
  $MsiFilePath = "${env:Temp}\Jenkins.msi"

  if (Test-Path -Path "$ZipFilePath")
  {
      Write-Host "Removing existing zip file : $ZipFilePath"
      Remove-Item -Path "$ZipFilePath"
  }
  Write-Host "Downloading Jenkins for Windows ..."
  Invoke-WebRequest -Uri "$JenkinsURL" -OutFile "$ZipFilePath"

  if (Test-Path -Path "$MsiFilePath")
  {
      Write-Host "Removing existing msi file : $MsiFilePath"
      Remove-Item -Path "$MsiFilePath"
  }
  Write-Host "Expanding a zip file of Jenkins ..."
  Expand-Archive -Path "$ZipFilePath" -DestinationPath ${env:Temp}

  $Arguments = ("/package", "`"$MsiFilePath`"", "/quiet")
  Write-Host "Starting Install Jenkins for Windows ..."
  $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $Arguments -NoNewWindow -Wait -PassThru
  $exitCode = $process.ExitCode

  if ($exitCode -eq 0 -or $exitCode -eq 3010)
  {
      Write-Host "Installed Jenkins for Windows successfully." -ForegroundColor Cyan
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

$exitCode = InstallJenkins

Write-Host -Object "Installation successful"
exit $exitCode
