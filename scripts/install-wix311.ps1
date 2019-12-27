
$InstallerURL = "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311.exe"

function InstallWixToolset
{
  Param
  (
    [String] $InstallerURL
  )

  Write-Host "Downloading..."
  $ExePath = "$env:TEMP\wix311.exe"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$ExePath"

  Write-Host "Installing..."
  $Arguments = @("/c", "`"`"$ExePath`" /q `"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  Remove-Item $ExePath
  if (($process.ExitCode -ne 0) -And ($process.ExitCode -ne 3010))
  {
    exit $process.ExitCode
  }
}

#-------------------------------------------------------------------------------

Write-Host "Installing WiX 3.11.2 ..." -ForegroundColor Cyan
InstallWixToolset -InstallerURL $InstallerURL
Write-Host "WiX 3.11.2 installed" -ForegroundColor Cyan

