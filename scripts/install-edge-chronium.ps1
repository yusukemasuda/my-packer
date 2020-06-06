$InstallerURL = "http://dl.delivery.mp.microsoft.com/filestreamingservice/files/39efe221-38fc-47ea-bfde-17afb0710d4a/MicrosoftEdgeEnterpriseX64.msi"

function InstallEdgeChronium
{
  Param
  (
    [String] $InstallerURL
  )

  Write-Host "Downloading..."
  $MsiPath = "$env:TEMP\MicrosoftEdgeEnterpriseX64.msi"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$MsiPath" -UseBasicParsing
  Write-Host "Downloaded: $MsiPath"

  Write-Host "Installing..."
  $Arguments = @("/c", "`"msiexec /i `"$MsiPath`" /quiet /norestart`"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  Remove-Item $MsiPath
  if (($process.ExitCode -ne 0) -And ($process.ExitCode -ne 3010))
  {
    exit $process.ExitCode
  }
}

#-------------------------------------------------------------------------------

Write-Host "Installing Microsoft Edge Chronium (Enterprise) ..." -ForegroundColor Cyan
InstallEdgeChronium -InstallerURL $InstallerURL
Write-Host "Microsoft Edge Chronium installed" -ForegroundColor Cyan
