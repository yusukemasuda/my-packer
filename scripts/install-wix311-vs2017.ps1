function InstallVs2017WixExtension
{
  Param
  (
    [String] $VSLocation,
    [String] $ExtensionURL
  )

  $exitCode = -1

  Write-Host "Downloading Wixtoolset Visual Studio 2017 Extension ..."
  $FilePath = "${env:Temp}\Votive2017.vsix"
  Invoke-WebRequest -Uri "$ExtensionURL" -OutFile "$FilePath"

  $VsixInstaller = "${VSLocation}\Common7\IDE\VSIXInstaller.exe"

  $Arguments = ("/c", "`"`"$VsixInstaller`" /quiet `"$FilePath`"`"")
  Write-Host "Starting Install Wixtoolset Visual Studio 2017 Extension ..."
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode

  if ($exitCode -ne 0)
  {
    Write-Host -Object "Non zero exit code returned by the installation process : $exitCode."
    exit $exitCode
  }
}

function FindVs2017Location()
{
  $VsPaths = @("${env:VS2017_HOME}"
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2015\Community",
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2015\Professional",
          "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2015\Enterprise")
  
  foreach ($VsPath in $VsPaths)
  {
    If (!([string]::IsNullOrEmpty($VsPath)) -And (Test-Path -PathType Container -Path "$VsPath"))
    {
      return $VsPath
    }
  }
  Write-Host "Visual Studio 2017 was not found." -ForegroundColor Red
  exit 99
}

#-------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"

$VSLocation = FindVs2017Location
$ExtensionURL = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/WixToolset/vsextensions/WixToolsetVisualStudio2017Extension/1.0.0.4/vspackage"

$exitCode = InstallVs2017WixExtension -VSLocation $VSLocation -ExtensionURL $ExtensionURL

Write-Host -Object "Installation successful"
return $exitCode
