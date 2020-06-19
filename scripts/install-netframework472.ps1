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
  Remove-Item $ExePath
  if (($process.ExitCode -ne 0) -And ($process.ExitCode -ne 3010))
  {
    exit $process.ExitCode
  }
}

#-------------------------------------------------------------------------------

Write-Host "Installing .NET Framework 4.7.2 ..." -ForegroundColor Cyan
InstallNetFramework -InstallerURL $InstallerURL
Write-Host "Microsoft .NET Framework 4.7.2 installed" -ForegroundColor Cyan
