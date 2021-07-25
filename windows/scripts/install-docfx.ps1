function InstallDocFx
{
  $Version = "v2.48.1"
  $DestinationPath = "${env:ProgramFiles}\docfx"
  $DocFxURL = "https://github.com/dotnet/docfx/releases/download/${Version}/docfx.zip"
  $exitCode = -1

  $ZipFilePath = "${env:Temp}\docfx.zip"

  if (Test-Path -Path "$ZipFilePath")
  {
      Write-Host "Removing existing zip file : ${ZipFilePath}"
      Remove-Item -Path "${ZipFilePath}"
  }
  Write-Host "Downloading DocFx ..."
  Invoke-WebRequest -Uri "${DocFxURL}" -OutFile "${ZipFilePath}"

  Write-Host "Expanding a zip file of Jenkins ..."
  Expand-Archive -Path "$ZipFilePath" -DestinationPath "${DestinationPath}"

  $path = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
  $path += ";${DestinationPath}"
  [Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$exitCode = InstallDocFx

Write-Host -Object "Installation successful"
exit $exitCode
