
$InstallerURL = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B7DFF5E82-6416-1DB0-1603-4037DFF8195D%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEB/dl/chrome/install/GoogleChromeEnterpriseBundle64.zip"

function InstallGoogleChrome
{
  Param
  (
    [String] $InstallerURL
  )

  Write-Host "Downloading..."
  $ZipPath = "$env:TEMP\GoogleChromeEnterpriseBundle64.zip"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$ZipPath" -UseBasicParsing
  Write-Host "Downloaded: $ZipPath"

  $ZipExtract = "$env:TEMP\GoogleChromeEnterpriseBundle64"
  Expand-Archive -Path "$ZipPath" -DestinationPath "$ZipExtract"
  Write-Host "Extracted Zip: $ZipExtract"

  $MsiPath = "$ZipExtract\Installers\GoogleChromeStandaloneEnterprise64.msi"
  Write-Host "Installing..."
  $Arguments = @("/c", "`"msiexec /i `"$MsiPath`" /quiet /norestart`"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode
  if ($exitCode -eq 0 -or $exitCode -eq 3010)
  {
    Write-Host -Object "Installation successful"
  Remove-Item "$ZipExtract" -Recurse
  Remove-Item "$ZipPath"
    Write-Host -Object "Cleaned up folder: `"$ZipExtract`""
    Write-Host -Object "Cleaned up folder: `"$ZipPath`""
  }
  else
  {
    Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
  }
  return $exitCode
}

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------

Write-Host "Installing Google Chrome ..." -ForegroundColor Cyan

InstallWixToolset -InstallerURL $InstallerURL
Write-Host "Google Chrome installed" -ForegroundColor Cyan