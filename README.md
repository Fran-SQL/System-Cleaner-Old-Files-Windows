# 🧹 System Cleaner Script (SystemCleaner.ps1)

Este script de PowerShell (`SystemCleaner.ps1`) está diseñado para realizar tareas de limpieza automática del sistema, enfocándose en la eliminación de archivos temporales del sistema operativo y en la purga de archivos antiguos dentro de una carpeta específica de tu elección.

## ⚙️ Configuración Obligatoria

Este script requiere un archivo llamado **config.json** en el mismo directorio para funcionar. Este archivo define la carpeta que debe ser limpiada y la antigüedad mínima de los archivos a borrar.

¡IMPORTANTE! Para que el script funcione, debes crear un archivo llamado config.json basado en el siguiente ejemplo:

Estructura config.json:
```bash
{
  "FolderPath": "C:\\Ruta\\Carpeta \\A\\Limpiar",
  "DaysOld": <cantidad en días>
}
```

Ejemplo:
```bash
{
  "FolderPath": "C:\\Usuario\\Downloads",
  "DaysOld": 365
}
```

## 📦 Qué Hace el Script
1. Lectura de Configuración: Lee config.json para obtener FolderPath y DaysOld.

2. Limpieza de Temporales: Limpia forzosamente los archivos y carpetas dentro de las rutas temporales estándar de Windows:

- $env:TEMP (Carpeta temporal del usuario)
- $env:WINDIR\Temp (Carpeta temporal del sistema)

3. Limpieza en carpeta específica: Elimina archivos de la ruta especificada en FolderPath que tengan una antigüedad superior a DaysOld.

4. Generación de Logs: Registra todas las acciones, incluyendo el espacio liberado de las carpetas en un archivo de log.

## 📜 Archivos de Log
El script crea una carpeta logs en su mismo directorio. Cada ejecución genera un archivo de log con fecha y hora para un seguimiento detallado, siguiendo el patrón "cleanup_log_YYYY-MM-DD_HH-mm-ss.txt".

## 🚀 Uso

El script se ejecuta a través de PowerShell. No necesita argumentos de línea de comandos, ya que toda su configuración se extrae del archivo `config.json`.

```bash
.\SystemCleaner.ps1
```

## 📖 Ejemplo resultados log

Lo que se muestra por consola es lo mismo que se registra en el log. 

```Fragmento de código
cleanup_log_2025-10-07_01-02-08.txt:
[2025-10-07 01:02:08] === Inicio de limpieza del sistema ===
[2025-10-07 01:02:08] Limpiando carpeta temporal: C:\Users\abc\AppData\Local\Temp
[2025-10-07 01:02:08] Espacio liberado en C:\Users\abc\AppData\Local\Temp : -0.08 MB
[2025-10-07 01:02:08] Limpiando carpeta temporal: C:\WINDOWS\Temp
[2025-10-07 01:02:08] Espacio liberado en C:\WINDOWS\Temp : 0 MB
[2025-10-07 01:02:08] Eliminando archivos de más de 365 días en: C:\Users\abc\Downloads
[2025-10-07 01:02:08] Archivos antiguos eliminados: 235
[2025-10-07 01:02:08] Espacio liberado por archivos antiguos: 0.65 MB
[2025-10-07 01:02:08] === Limpieza finalizada correctamente ===
```

# ⚠️ Consideraciones de Seguridad y Permisos
- El script necesita permisos de escritura y eliminación sobre todas las rutas que intenta limpiar, incluyendo las carpetas temporales de Windows y la ruta especificada en FolderPath.

- Asegúrate de que la ruta en FolderPath solo contenga archivos que puedan ser eliminados sin riesgo (ej. logs, copias de seguridad antiguas, temporales de aplicaciones), ya que la acción de borrado es permanente.
