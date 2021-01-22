$InstallDrive = "C:"
$InstallDir = "$InstallDrive\openjdk"

function InstallOpenJDK
{
  $OpenJdkURL = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_windows-x64_bin.zip"

  $ZipFilePath = "${env:Temp}\openjdk_windows-x64_bin.zip"

  if (Test-Path -Path "$InstallDir")
  {
      Write-Host "Removing existing install folder : $InstallDir"
      Remove-Item -Path "$InstallDir" -Recurse
  }

  if (Test-Path -Path "$ZipFilePath")
  {
      Write-Host "Removing existing zip file : $ZipFilePath"
      Remove-Item -Path "$ZipFilePath"
  }
  Write-Host "Downloading OpenJDK for Windows ..."
  Invoke-WebRequest -Uri "$OpenJdkURL" -OutFile "$ZipFilePath"

  Write-Host "Expanding OpenJDK for Windows ... [$InstallDir]"
  Expand-Archive -Path "$ZipFilePath" -DestinationPath "$InstallDrive\"
  Rename-Item -Path "$InstallDrive\jdk-14.0.2" "$InstallDir"
  Remove-Item -Path "$ZipFilePath"

  Write-Host "Configuring environment variables"
  [System.Environment]::SetEnvironmentVariable("JAVA_HOME", "$InstallDir", "Machine")
  [System.Environment]::SetEnvironmentVariable("PATH", "$InstallDir\bin;${env:PATH}", "Machine")

  return 0
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$exitCode = InstallOpenJDK

Write-Host -Object "Installation successful"
exit $exitCode
