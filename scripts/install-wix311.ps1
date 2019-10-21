
function EnsureNetFramework3Installed
{
  $RegistryKey = "Registry::HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5"
  if ((!(Test-Path -Path $RegistryKey)) -Or ((Get-Item -Path $RegistryKey).GetValue("Install") -ne 1))
  {
      Write-Host "Enabling .NET Framework 3.1..." -ForegroundColor Cyan
      $Arguments = @("/c", "DISM.exe /Quiet /Online /Enable-Feature /FeatureName:NetFX3 /All")
      $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
      if ($process.ExitCode -ne 0)
      {
        exit $process.ExitCode
      }
      Write-Host ".NET Framework 3.1 enabled." -ForegroundColor Cyan
  }
}

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

$InstallerURL = "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311.exe"

EnsureNetFramework3Installed

Write-Host "Installing WiX 3.11.2 ..." -ForegroundColor Cyan
InstallWixToolset -InstallerURL $InstallerURL
Write-Host "WiX 3.11.2 installed" -ForegroundColor Cyan

