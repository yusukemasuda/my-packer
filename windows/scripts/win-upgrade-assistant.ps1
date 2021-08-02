function Write-Log { 
    [CmdletBinding()] 
    param ( 
        [Parameter(Mandatory)] 
        [string]$Message
    ) 
      
    try { 
        if (!(Test-Path -path ([System.IO.Path]::GetDirectoryName($LogFilePath)))) {
            New-Item -ItemType Directory -Path ([System.IO.Path]::GetDirectoryName($LogFilePath))
        }
        $DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Value "$DateTime - $Message" -Path $LogFilePath
        Write-Host $Message
    } 
    catch { 
        Write-Error $_.Exception.Message 
    } 
}
Function CheckIfElevated() {
    Write-Log "Info: Checking for elevated permissions..."
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Log "ERROR: Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
        return $false
    }
    else {
        Write-Log "Info: Code is running as administrator - go on executing the script..."
        return $true
    }
}
 
# Main
 
try {
    # Declarations
    [string]$DownloadDir = "${env:Temp}"
    [string]$LogDir = "C:\Windows\Temp"
    [string]$LogFilePath = [string]::Format("{0}\{1}_{2}.log", $LogDir, $MyInvocation.MyCommand.Name.Replace(".ps1", ""), "$(get-date -format `"yyyyMMdd_HHmmss`")")
    [string]$Url = 'https://go.microsoft.com/fwlink/?LinkID=799445'
    [string]$UpdaterBinary = "$($DownloadDir)\Win10Upgrade.exe"
    [string]$UpdaterArguments = '/QuietInstall /SkipEula /NoReboot /NoRestartUI /NoRestart /Auto upgrade /CopyLogs $LogDir'
 
    # Here the music starts playing .. 
    Write-Log -Message ([string]::Format("Info: Script init - User: {0} Machine {1}", $env:USERNAME, $env:COMPUTERNAME))
    Write-Log -Message ([string]::Format("Current Windows Version: {0}", [System.Environment]::OSVersion.ToString()))
     
    # Check if script is running as admin and elevated  
    if (!(CheckIfElevated)) {
        Write-Log -Message "ERROR: Will terminate!"
        break
    }
 
    # Check if folders exis
    if (!(Test-Path $DownloadDir)) {
        New-Item -ItemType Directory -Path $DownloadDir
    }
    if (!(Test-Path $LogDir)) {
        New-Item -ItemType Directory -Path $LogDir
    }
    if (Test-Path $UpdaterBinary) {
        Remove-Item -Path $UpdaterBinary -Force
    }
    # Download the Windows Update Assistant
    Write-Log -Message "Will try to download Windows Update Assistant.."
    Invoke-WebRequest -Uri "$Url" -OutFile "$UpdaterBinary"

    # If the Update Assistant exists -> create a process with argument to initialize the update process
    if (Test-Path $UpdaterBinary) {
        $process = Start-Process -FilePath $UpdaterBinary -ArgumentList $UpdaterArguments -Wait -PassThru
        $exitCode = $process.ExitCode
        if ($exitCode -eq 0 -or $exitCode -eq 3010)
        {
            Write-Log "Installation successful"
        }
        else
        {
            Write-Log "Non zero exit code returned by the installation process : $exitCode."
        }
        Write-Log "Fired and forgotten?"
        exit $exitCode
    }
    else {
        Write-Log -Message ([string]::Format("ERROR: File {0} does not exist!", $UpdaterBinary))
        exit 9
    }
}
catch {
    Write-Log -Message $_.Exception.Message 
    Write-Error $_.Exception.Message 
    exit -1
}

