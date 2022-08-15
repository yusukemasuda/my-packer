function InstallVs2022WixExtension
{
  Param
  (
    [String] $VSLocation,
    [String] $ExtensionURL
  )

  $exitCode = -1

  Write-Host "Downloading Wixtoolset Visual Studio 2022 Extension ..."
  $FilePath = "${env:Temp}\Votive2022.vsix"
  Invoke-WebRequest -Uri "$ExtensionURL" -OutFile "$FilePath"

  $VsixInstaller = "${VSLocation}\Common7\IDE\VSIXInstaller.exe"

  $Arguments = ("/c", "`"`"$VsixInstaller`" /quiet `"$FilePath`"`"")
  Write-Host "Starting Install Wixtoolset Visual Studio 2022 Extension ..."
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode

  if ($exitCode -ne 0)
  {
    Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
    exit $exitCode
  }
}

function FindVs2022Location()
{
  $VsPaths = @("${env:VS2022_HOME}"
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Community",
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Professional",
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2022\Enterprise")
  
  foreach ($VsPath in $VsPaths)
  {
    If (!([string]::IsNullOrEmpty($VsPath)) -And (Test-Path -PathType Container -Path "$VsPath"))
    {
      return $VsPath
    }
  }
  Write-Host "Visual Studio 2022 was not found." -ForegroundColor Red
  exit 99
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$VSLocation = FindVs2022Location
$ExtensionURL = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/WixToolset/vsextensions/WixToolsetVisualStudio2022Extension/1.0.0.18/vspackage"

$exitCode = InstallVs2022WixExtension -VSLocation $VSLocation -ExtensionURL $ExtensionURL

Write-Host -Object "Installation successful"
return $exitCode
