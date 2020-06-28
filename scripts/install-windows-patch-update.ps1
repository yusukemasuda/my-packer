
    Param (
        [parameter(Mandatory=$true)]
        [string]$KB,
        [parameter(Mandatory=$false)]
        [string]$OSVersion = $null,
        [parameter(Mandatory=$false)]
        [string]$Platform = $null,
        [parameter(Mandatory=$false)]
        [string]$OSBuild = $null
    )

    $ONEURL="https://www.catalog.update.microsoft.com/Search.aspx?q=$KB"
    $PLATFORM_FILTERS = @{
        'x86'   = { param($platform) $platform -eq 'x86' -or $platform -eq $null }
        'x64'   = { param($platform) $platform -eq 'x64' }
        'arm64' = { param($platform) $platform -eq 'arm64'}
    }

    $UPDATE_CATALOG_DOWNLOAD_LINK='http://www.catalog.update.microsoft.com/DownloadDialog.aspx'
    $UPDATE_URL_PATTERN =  "https?://download\.windowsupdate\.com\/[^ \'\""]+"
    $POST_BODY_TEMPLATE = '"updateID": "{0}"'

    $DOWNLOAD_RESULT=@()

    Write-Host "Checking if $KB has already installed."
    $AlreadyInstalled = (Get-HotFix "$KB" -ErrorAction SilentlyContinue)
    if ($AlreadyInstalled -ne $null)
    {
        Write-Host "Already installed: [$($AlreadyInstalled.HotFixID)] $($AlreadyInstalled.Description)" -ForegroundColor Red
        return;
    }
    else
    {
        Write-Host "Not installed: [$($KB)] $($AlreadyInstalled.Description)" -ForegroundColor Cyan
    }


    Write-Host ""
    Write-Host "Connecting to URL $ONEURL." -ForegroundColor Gray

    $LINKS = (Invoke-WebRequest -Uri $ONEURL) | %{ $_.Links } | Where-Object id -like '*_link' | %{
        $_ | Select-Object `
            @{ Name = 'GUID';     Expression = { $_.Id -replace '_link', '' } },
            @{ Name = 'platform'; Expression = {
                if ( $_.innerText -match '\b(x86|x64|arm64)\b')
                {
                    $Matches[1].ToLower()
                }
            } },
            @{ Name = 'innertext';     Expression = { $_.innertext } }
    }

    if($LINKS -eq $null)
    {
        Write-Host "No such kb article exit" -ForegroundColor Red
        return;
    }

    # Filter links that match parameter
    if (-not [string]::IsNullOrEmpty($Platform))
    {
        $LINKS = $LINKS | Where-Object { Invoke-Command $PLATFORM_FILTERS[$Platform.ToLower()] -ArgumentList $_.platform }
    }
    if (-not [string]::IsNullOrEmpty($OSVersion))
    {
        $LINKS = $LINKS | Where-Object { $_.innertext -match $OSVersion }
    }
    if (-not [string]::IsNullOrEmpty($OSBuild))
    {
        $LINKS = $LINKS | Where-Object { $_.innertext -match $OSBuild }
    }

    if($LINKS -eq $null)
    {
        Write-Host "No kb article filtered" -ForegroundColor Red
        return;
    }

    Write-Host "List of patches found:" -ForegroundColor Green
    Write-Host  $($LINKS.innerText) -ForegroundColor Gray
    Write-Host ""

    #Creating folder for each specific KB article
    $KB_ROOT_FOLDER = "${env:Temp}\WindowsPatches\$KB"
    if(Test-Path $KB_ROOT_FOLDER)
    {
        Remove-Item $KB_ROOT_FOLDER -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Path $KB_ROOT_FOLDER -ErrorAction SilentlyContinue | Out-Null

    foreach ($ONELINK in $LINKS)
    {
        $DOWNLOAD_FOLDER_NAME = $DOWNLOAD_FILE_NAME = $DOWNLOAD_LINK = $DOWNLOAD_PATH = $null

        if ($ONELINK -eq $null) {
            continue
        }

        Write-Host "Processing link: $($ONELINK.innerText)"

        $DOWNLOAD_LINK = $null
        $POST_BODY = @{ updateIDs = "[{$( $POST_BODY_TEMPLATE -f ($ONELINK.GUID) )}]" }
        if (( Invoke-WebRequest -Uri $UPDATE_CATALOG_DOWNLOAD_LINK -Method Post -Body $POST_BODY).Content -match $UPDATE_URL_PATTERN)
        {
            $DOWNLOAD_LINK = $Matches[0]
        }
        else
        {
            Write-Host "Source URL for patch $ONELINK does not exist" -ForegroundColor Red
            continue
        }

        $DOWNLOAD_FOLDER_NAME = $ONELINK.innerText.TrimEnd(" ")
        $DOWNLOAD_FILE_NAME   = ($DOWNLOAD_LINK -split "/")[-1]

        Write-Host "Downloading update $DOWNLOAD_FILE_NAME...."
        New-Item -ItemType Directory -Path "$KB_ROOT_FOLDER\$DOWNLOAD_FOLDER_NAME" | Out-Null
        $DOWNLOAD_PATH = "$KB_ROOT_FOLDER\$DOWNLOAD_FOLDER_NAME\$DOWNLOAD_FILE_NAME"

        try 
        {
            Invoke-WebRequest $DOWNLOAD_LINK -OutFile $DOWNLOAD_PATH  
            Write-Host "Download completed for update $DOWNLOAD_FILE_NAME" -ForegroundColor Green

            $Arguments = @("/c", "`"WUSA.exe `"$DOWNLOAD_PATH`" /Quiet /NoRestart`"")
            $process = Start-Process -FilePath "cmd.exe" -ArgumentList $Arguments -Wait -PassThru
            $exitCode = $process.ExitCode
            if ($exitCode -eq 0 -or $exitCode -eq 3010)
            {
                Write-Host "Installed: $($ONELINK.innerText)" -ForegroundColor Cyan
            }
            else {
                Write-Host "Installation failed: exitCode: $($exitCode), $($ONELINK.innerText)" -ForegroundColor Red
            }
        }
        catch 
        {
            Write-Host "Exception occured during download." -Foreground Red
            continue
        }
    }
    return;

# OSVersion: 'Windows 8.1', 'Windows Server 2012 R2'
# Platform:  'x86', 'x64', 'amd64'


#Get-WindowsPatches -KB "KB4103715" -OSVersion "Windows Server 2012 R2" -Platform "x64"
