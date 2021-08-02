
Set-Variable -Name POWER_PLAN_GUID_HIGH_PERF -Value "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" -Option Constant

try {
  Write-Output "Set power plan to High-Performance '$POWER_PLAN_GUID_HIGH_PERF'"
  if ((POWERCFG /LIST | Where({ $_.Contains($POWER_PLAN_GUID_HIGH_PERF) })).Count -le 0) {
    throw "Error: Power management plan 'High-Performance' does not exists"
  }

  POWERCFG /S $POWER_PLAN_GUID_HIGH_PERF
  if ($LASTEXITCODE -ne 0) {
    throw "Error: Failed to configure power plan to '$POWER_PLAN_GUID_HIGH_PERF'"
  }

  Write-Output "Power plan High-Perfomance '$POWER_PLAN_GUID_HIGH_PERF' was successfully activated"

} catch {
  Write-Warning -Message "Unable to set power plan to High-Perfomance '$POWER_PLAN_GUID_HIGH_PERF'"
  Write-Warning $Error[0]
}


