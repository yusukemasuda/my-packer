netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=block
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
netsh advfirewall firewall set rule name="Windows �����[�g�Ǘ� (HTTP ��M)" new enable=yes action=block
netsh advfirewall firewall set rule group="Windows �����[�g�Ǘ�" new enable=yes
$winrmService = Get-Service -Name WinRM
if ($winrmService.Status -eq "Running"){
    Disable-PSRemoting -Force
}
Stop-Service winrm
Set-Service -Name WinRM -StartupType Disabled
