$InstallerURLs = @{
 "en" = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/2000920063/AcroRdrDC2000920063_en_US.exe"
 "ja" = "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/2000920063/AcroRdrDC2000920063_ja_JP.exe"
}

function InstallAdobeReader
{
  Param
  (
    [String] $InstallerURL
  )

  $uri = New-Object System.Uri($InstallerURL)
  $file = Split-Path $uri.AbsolutePath -Leaf

  Write-Host "Downloading..."
  $ExePath = "$env:TEMP\$file"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$ExePath"

  Write-Host "Installing..."
  $Arguments = @("/c", "`"`"$ExePath`" /sAll /rps /l`"" )
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
Write-Host "Installing Adobe Reader ..." -ForegroundColor Cyan

$Lang = "en"
Get-Culture | %{
  if ($_.LCID -eq 1041)
  {
    $Lang = "ja"
  }
}
Write-Host "Selected Language: [$Lang]"
InstallAdobeReader -InstallerURL $InstallerURLs[$Lang]
Write-Host "Adobe Reader installed" -ForegroundColor Cyan

