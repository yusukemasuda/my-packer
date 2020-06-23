$InstallerURLs = @{
 "en" = "https://aka.ms/highdpimfc2013x64enu"
 "ja" = "https://aka.ms/highdpimfc2013x64jpn"
}

function InstallVcRed2013
{
  Param
  (
    [String] $InstallerURL
  )

  Write-Host "Downloading..."
  $ExePath = "$env:TEMP\vcredist_x64.exe"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$ExePath"

  Write-Host "Installing..."
  $Arguments = @("/c", "`"`"$ExePath`" /install /quiet /norestart`"" )
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
Write-Host "Installing Visual C++ 2013 Redistributable ..." -ForegroundColor Cyan

$Lang = "en"
Get-Culture | %{
  if ($_.LCID -eq 1041)
  {
    $Lang = "ja"
  }
}
Write-Host "Selected Language: [$Lang]"
InstallVcRed2013 -InstallerURL $InstallerURLs[$Lang]
Write-Host "Visual C++ 2013 Redistributable installed" -ForegroundColor Cyan

