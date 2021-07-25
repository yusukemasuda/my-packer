$InstallerURL = "http://go.microsoft.com/fwlink/?linkid=863265"

function InstallNetFramework
{
  Param
  (
    [String] $InstallerURL
  )

  Write-Host "Downloading..."
  $ExePath = "$env:TEMP\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$ExePath" -UseBasicParsing
  Write-Host "Downloaded: $ExePath"

  Write-Host "Installing..."
  $Arguments = @("/c", "`"`"$ExePath`" /quiet /norestart`"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode
  if ($exitCode -eq 0 -or $exitCode -eq 3010)
  {
    Write-Host -Object "Installation successful"
    Remove-Item "$ExePath"
    Write-Host -Object "Cleaned up file: `"$ExePath`""
  }
  else
  {
    Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
  }
  return $exitCode
}

#-------------------------------------------------------------------------------

Write-Host "Installing .NET Framework 4.7.2 ..." -ForegroundColor Cyan
InstallNetFramework -InstallerURL $InstallerURL
Write-Host "Microsoft .NET Framework 4.7.2 installed" -ForegroundColor Cyan
