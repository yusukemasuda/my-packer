$InstallerURL = "https://osdn.net/frs/redir.php?m=gigenet&f=%2Fstorage%2Fg%2Ft%2Fto%2Ftortoisesvn%2FArchive%2F1.10.1%2FApplication%2FTortoiseSVN-1.10.1.28295-x64-svn-1.10.2.msi"
$LangPackURL = "https://osdn.net/frs/redir.php?m=gigenet&f=%2Fstorage%2Fg%2Ft%2Fto%2Ftortoisesvn%2FArchive%2F1.10.1%2FLanguage+Packs%2FLanguagePack_1.10.1.28295-x64-ja.msi"

function InstallTortoiseSVN
{
  Param
  (
    [String] $InstallerURL
  )

  # -------------------------------------------------------
  #    Download TortoiseSVN
  # -------------------------------------------------------
  Write-Host "Downloading Application MSI..."
  $AppMsiPath = "$env:TEMP\TortoiseSVN-x64.msi"
  Invoke-WebRequest -Uri $InstallerURL -OutFile "$AppMsiPath" -UseBasicParsing
  Write-Host "Downloaded: $AppMsiPath"

  # -------------------------------------------------------
  #    Download Language Pack
  # -------------------------------------------------------
  Write-Host "Downloading Language Pack MSI..."
  $LPMsiPath = "$env:TEMP\TortoiseSVN-LanguagePack.msi"
  Invoke-WebRequest -Uri $LangPackURL -OutFile "$LPMsiPath" -UseBasicParsing
  Write-Host "Downloaded: $LPMsiPath "

  # -------------------------------------------------------
  #    Install TortoiseSVN
  # -------------------------------------------------------
  Write-Host "Installing Application..."
  $Arguments = @("/c", "`"msiexec /i `"$AppMsiPath`" /quiet /norestart ADDLOCAL=ALL`"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode
  if ($exitCode -eq 0 -or $exitCode -eq 3010)
  {
    Write-Host -Object "Installation successful"
    Remove-Item "$AppMsiPath"
    Write-Host -Object "Cleaned up file: `"$AppMsiPath`""
  }
  else
  {
    Write-Host -Object "[Application] Non zero exit code returned by the installation process : $exitCode."
    return $exitCode
  }

  # -------------------------------------------------------
  #    Install Language Pack
  # -------------------------------------------------------
  Write-Host "Installing Language Pack..."
  $Arguments = @("/c", "`"msiexec /i `"$LPMsiPath`" /quiet /norestart`"" )
  $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
  $exitCode = $process.ExitCode
  if ($exitCode -eq 0 -or $exitCode -eq 3010)
  {
    Write-Host -Object "Installation successful"
    Remove-Item "$LPMsiPath"
    Write-Host -Object "Cleaned up file: `"$LPMsiPath`""
  }
  else
  {
    Write-Host -Object "[Language Pack] Non zero exit code returned by the installation process : $exitCode."
    return $exitCode
  }

  return 0
}

#-------------------------------------------------------------------------------

Write-Host "Installing TortoiseSVN ..." -ForegroundColor Cyan
InstallTortoiseSVN -InstallerURL $InstallerURL
Write-Host "TortoiseSVN installed" -ForegroundColor Cyan
