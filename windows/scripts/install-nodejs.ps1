$ErrorActionPreference = "Stop"

function ParseHtml($String) {
    $Unicode = [System.Text.Encoding]::Unicode.GetBytes($String)
    $html = New-Object -Com 'HTMLFile'
    if ($html.PSObject.Methods.Name -Contains 'IHTMLDocument2_Write') {
        $html.IHTMLDocument2_Write($Unicode)
    } 
    else {
        $html.write($Unicode)
    }
    $html.Close()
    $html
}

function GetEnvironmentVariable($name) {
    $value = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" | Select-Object -ExpandProperty $name
    Write-Host "Get EnvironmentVariable [$name]: $value"
    $value
}

function InstallNodeVersionManager() {
    $url = "https://github.com/coreybutler/nvm-windows/releases/latest"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $html = ParseHtml($response.Content)
    $downloadUrl = $html.GetElementsByTagName("a") | %{ $_.Href } | ? { $_.endsWith("nvm-setup.exe") } | Select-Object -First 1
    $downloadUrl = $downloadUrl -replace "about:", "https://github.com"

    Write-Host "Downloading NVM for Windows ..."
    Write-Host " ... From: $downloadUrl"
    
    $filePath = "${env:Temp}\nvm-setup.exe"
    if (Test-Path -Path "$filePath")
    {
        Remove-Item -Path "$filePath"
    }
    Invoke-WebRequest -Uri "$downloadUrl" -OutFile "$filePath" -UseBasicParsing

    Write-Host "Starting Install NVM for Windows ..."
    $process = Start-Process -FilePath "`"$FilePath`"" -ArgumentList ("/silent") -Wait -PassThru
    $exitCode = $process.ExitCode

    if ($exitCode -eq 0 -or $exitCode -eq 3010)
    {
        Write-Host "Installed NVM for Windows successfully." -ForegroundColor Cyan
    }
    else
    {
        throw "Non zero exit code returned by the NVM installation process : $exitCode."
    }
    $env:NVM_HOME = GetEnvironmentVariable("NVM_HOME")
    $env:NVM_SYMLINK = GetEnvironmentVariable("NVM_SYMLINK")
    $env:PATH = GetEnvironmentVariable("PATH")
}

function ExecuteCommand($command) {
    Write-Host "Executing Command `"$command`""
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "`"$command`"") -Wait -PassThru
    $exitCode = $process.ExitCode
    if ($exitCode -ne 0)
    {
        throw "Abnormal exit code by `"$command`" Exit: $exitCode"
    }
    Write-Host "Completed Command `"$command`""
}

function InstallNodeJsWithRecommendedVersion() {
    $url = "https://nodejs.org/"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing

    $html = ParseHtml($response.Content)
    # classで絞り込み
    $anchors = $html.GetElementsByTagName("a") | ? { $_.className -eq "home-downloadbutton" }
    $version = $anchors | %{ ([RegEx]::Matches($_.nameProp, "(v[0-9]+(\.[0-9]+)+)")).Value } | Select-Object -First 1

    Write-Host "Install NodeJS $version"
    ExecuteCommand("nvm install $version")

    Write-Host "Use NodeJS $version"
    ExecuteCommand("nvm use $version")
}

InstallNodeVersionManager
InstallNodeJsWithRecommendedVersion
