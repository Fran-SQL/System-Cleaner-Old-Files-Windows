# --- PROGRAMAR AUTOMATIZACIÓN SystemCleaner.ps1 ---
$taskName = "SystemCleaner_Automatico" # Nombre tarea
$scriptPath = Join-Path $PSScriptRoot "SystemCleaner.ps1" # Ruta donde está SystemCleaner.ps1

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`"" # Cómo ejecutar script
$trigger = New-ScheduledTaskTrigger -Daily -At 10:30am # Cuándo se ejecuta el script, ejemplo diariamente a las 10:30AM
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest # conceder privilegios más altos para poder limpiar carpetas del sistema como Temp

Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description "Limpieza diaria del sistema con PowerShell"

Write-Host "Tarea programada '$taskName' creada correctamente."
