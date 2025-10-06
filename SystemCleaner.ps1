# =============================================
# SystemCleaner.ps1
# Script para limpiar archivos temporales y liberar espacio
# =============================================

# --- CONFIGURACIÓN ---
$fecha = Get-Date -Format "yyyy-MM-dd_HH-mm-ss" # Obtiene fecha y hora actual
$logDir = "$PSScriptRoot\logs" # ruta donde se guardarán los logs
$logFile = "$logDir\cleanup_log_$fecha.txt" # nombre del log generado con fecha incluida
$daysOld = 366  # define cuántos días debe tener un archivo para ser eliminado

# Crear carpeta de logs si no existe
if (!(Test-Path -Path $logDir)) { # Si no existe la ruta $logDir (ruta/logs) entonces...
    New-Item -ItemType Directory -Path $logDir | Out-Null # se crea la carpeta logs en $logDir
}

# --- FUNCIONES AUXILIARES ---

# Para escribir en consola y archivo log 
function Write-Log {
    param([string]$message) # usa el parámetro message que es un string
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss" # recoge la fecha de hoy
    $entry = "[$timestamp] $message" # junta la fecha de hoy con la string del parámetro
    Write-Output $entry # visualizar en consola la palabra nueva generada
    Add-Content -Path $logFile -Value $entry # escribir la palabra nueva en el archivo log
}

# Para calcular tamaño carpeta
function Get-FolderSize {
    param([string]$path)
    if (Test-Path $path) {
        (Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | # listar todos los archivos dentro
         Measure-Object -Property Length -Sum).Sum / 1MB # sumar los tamaños y dividir por 1MB para pasar Bytes a MegaBytes
    } else {
        return 0
    }
}

# --- INICIO DEL SCRIPT ---
Write-Log "=== Inicio de limpieza del sistema ==="

# Limpieza de carpetas temporales
# Rutas a limpiar
$tempPaths = @( # crea lista con rutas de las carpetas temporales
    "$env:TEMP", # carpeta temporal de usuario
    "$env:WINDIR\Temp" # carpeta temporal de sistema
)

foreach ($path in $tempPaths) {
    if (Test-Path $path) {
        $before = Get-FolderSize $path # calcular tamaño antes de limpiar con $before
        Write-Log "Limpiando carpeta temporal: $path"

        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue # borrar todos los archivos dentroc on Remove-Item

        $after = Get-FolderSize $path # calcular el tamño después del borrado con $after
        $freed = [math]::Round(($before - $after), 2) # calcular diferencia y hacer redondeo
        Write-Log "Espacio liberado en $path: $freed MB"
    } else {
        Write-Log "Ruta no encontrada: $path"
    }
}

# --- LIMPIAR ARCHIVOS ANTIGUOS EN CARPETA ---
$target_file = "$env:USERPROFILE\OneDrive\Documentos\Sony" # carpeta que se limpia
Write-Log "Eliminando archivos de más de $daysOld días en: $target_file"

$oldFiles = Get-ChildItem -Path $target_file -Recurse -File | # listar todos los archivos de la carpeta objetivo
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) } # filtra los que fueron modificados hace más de $daysOld días

foreach ($file in $oldFiles) {
    Remove-Item $file.FullName -Force -ErrorAction SilentlyContinue # borrar cada archivo que corresponda
}

Write-Log "Archivos antiguos eliminados: $($oldFiles.Count)" # registrar cantidad archivos eliminados

Write-Log "=== Limpieza finalizada correctamente ==="
