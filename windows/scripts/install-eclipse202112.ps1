
function InstallEclipse
{
  $EclipseURL = "https://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/2021-12/R/eclipse-jee-2021-12-R-win32-x86_64.zip"
  $LombokURL = "https://projectlombok.org/downloads/lombok.jar"

  $ZipFilePath = "${env:Temp}\eclipse-jee-R-win32-x86_64.zip"

  if (Test-Path -Path "C:\eclipse")
  {
      Write-Host "Removing existing install folder"
      Remove-Item -Path "C:\eclipse" -Recurse
  }

  if (Test-Path -Path "$env:USERPROFILE\Desktop\Eclipse.lnk")
  {
      Write-Host "Removing existing shortcut"
      Remove-Item -Path "$env:USERPROFILE\Desktop\Eclipse.lnk"
  }

  if (Test-Path -Path "$ZipFilePath")
  {
      Write-Host "Removing existing zip file : $ZipFilePath"
      Remove-Item -Path "$ZipFilePath"
  }
  Write-Host "Downloading Eclipse for Windows ..."
  Invoke-WebRequest -Uri "$EclipseURL" -OutFile "$ZipFilePath"

  Write-Host "Expanding Eclipse for Windows ..."
  Expand-Archive -Path "$ZipFilePath" -DestinationPath "C:\"
  Remove-Item -Path "$ZipFilePath"

  Write-Host "Configuring environment variables"
  [System.Environment]::SetEnvironmentVariable("ECLIPSE_HOME", "C:\eclipse", "Machine")

  $WshShell = New-Object -ComObject WScript.Shell
  $ShortCut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Eclipse.lnk")
  $ShortCut.TargetPath = "C:\eclipse\eclipse.exe"
  $ShortCut.Save()

  Invoke-WebRequest -Uri "$LombokURL" -OutFile "C:\eclipse\lombok.jar"
  Add-Content -Value "-javaagent:C:\eclipse\lombok.jar" -Path "C:\eclipse\eclipse.ini" 

  return 0
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$exitCode = InstallEclipse

Write-Host -Object "Installation successful"
exit $exitCode
