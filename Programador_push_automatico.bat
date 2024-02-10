C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2\Programador_push_automatico2.bat

@echo off

:: Verificar si la tarea ya está programada
schtasks /query /tn "Auto Push Git" > nul 2>&1
if %errorlevel% equ 0 (
    echo La tarea ya está programada.
) else (
    echo La tarea aún no está programada.
    :: Programar la tarea en el Programador de tareas para ejecutar este script cada 30 minutos
    schtasks /create /sc minute /mo 30 /tn "Auto Push Git" /tr "C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2\Programador_push_automatico.bat" /rl HIGHEST
)

:: Definir las variables con la ruta de mi repo y la rama específica donde se va a subir automáticamente.
set "WORKING_DIR=C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2"
set "BRANCH=borja_rama_toco"

:: Cambiar al directorio del repo
cd /d %WORKING_DIR%

:: Realizar un pull para obtener los últimos cambios de la rama remota
git pull origin %BRANCH%

:: Verificar si hay cambios en la rama
git diff-index --quiet HEAD --
if %errorlevel% equ 0 (
    echo No hay cambios para subir.
) else (
    :: Añadir los cambios si los hay de mi rama
    git add .

    :: Crear un commit con una marca de tiempo
    git commit -m "Commit automático de Borja %date% %time%"

    :: Realizar el push al repositorio remoto sin solicitar confirmación al usuario
    git push origin %BRANCH%
)
