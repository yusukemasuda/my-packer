
function EnsureNetFramework3Installed
{
  $RegistryKey = "Registry::HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5"
  if ((!(Test-Path -Path $RegistryKey)) -Or ((Get-Item -Path $RegistryKey).GetValue("Install") -ne 1))
  {
      Write-Host "Enabling .NET Framework 3.1..." -ForegroundColor Cyan
      $Arguments = @("/c", "DISM.exe /Quiet /NoRestart /Online /Enable-Feature /FeatureName:NetFX3 /All")
      $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
      $exitCode = $process.ExitCode
      if ($exitCode -eq 0 -or $exitCode -eq 3010)
      {
          Write-Host ".NET Framework 3.1 enabled." -ForegroundColor Cyan
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
  else
  {
      Write-Host "Skipped to install, because .NET Framework 3.1 has been installed ..." -ForegroundColor DarkYellow
  }
}

#-------------------------------------------------------------------------------


Write-Host "Attempting to install .NET Framework 3.1 ..." -ForegroundColor Cyan

$exitCode = EnsureNetFramework3Installed

Write-Host "Has been ensured to install .NET Framework 3.1" -ForegroundColor Cyan

return $exitCode

