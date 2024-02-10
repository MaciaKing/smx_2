@echo off

:: Definimos las variables con la ruta de mi repo y la rama específica donde se va a subir automáticamente.
set WORKING_DIR="C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2"
set BRANCH=borja_rama_toco

:: Cambia al directorio del repo
cd /d %WORKING_DIR%

:: Verifica si hay cambios en la rama
git diff-index --quiet HEAD --
if %errorlevel% equ 0 (
    echo No hay cambios para subir.
) else (
    :: Realiza un pull para obtener los últimos cambios de la rama remota
    git pull origin %BRANCH%

    :: Añade los cambios si los hay de mi rama
    git add .

    :: Crea un commit con una marca de tiempo
    git commit -m "Commit automático de Borja %date% %time%"

    :: Realiza el push al repositorio remoto sin solicitar confirmación al usuario
    git push origin %BRANCH%
)

:: Verifica si la tarea ya está programada
schtasks /query /tn "Auto Push Git" > nul 2>&1
if %errorlevel% equ 0 (
    echo La tarea ya está programada.
    exit /b
)

:: Programa la tarea en el Programador de tareas para ejecutar este script cada 30 minutos con privilegios elevados
schtasks /create /sc minute /mo 30 /tn "Auto Push Git" /tr "C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2\Programador_push_automatico.bat" /rl HIGHEST
