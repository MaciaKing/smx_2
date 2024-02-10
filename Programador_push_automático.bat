@echo off

:: definimos las variables con la ruta de mi repo y la rama específica donde se va a subir automáticamente.
set WORKING_DIR="C:\Users\bsilv\Desktop\REPOS\repomacia\smx_2"
set BRANCH=borja_rama_toco

:: Cambia al directorio del repo
cd %WORKING_DIR%

:: Verifica si hay cambios en la rama
git diff-index --quiet HEAD --
if %errorlevel% equ 0 (
    echo No hay cambios para subir.
) else (
    :: Añade los cambios si los hay de mi rama
    git add .

    :: Crea un commit con una marca de tiempo
    git commit -m "Commit automático de Borja %date% %time%"

    :: utilizo la función choice para que se pueda confirmar el push al repositorio remoto y evitar que se suba algo por error.
    choice /C SN /M "¿Quieres hacer push al repositorio remoto? S/N: "
    if %errorlevel% equ 1 (
        :: Si el usuario elige 'S', entonces realiza el push
        git push origin %BRANCH%
    ) else (
        echo No se realizará el push al repositorio remoto.
    )
)

:: Programa la tarea en el Programador de tareas para ejecutar este script cada 30 minutos
schtasks /create /sc minute /mo 30 /tn "Auto Push Git" /tr "C:\ruta\a\tu\repositorio\local\git_auto_push.bat"