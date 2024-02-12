#!/bin/bash

# Verificar si la tarea ya está programada
if crontab -l | grep -q "Auto Push Git"; then
    echo "La tarea ya está programada."
else
    echo "La tarea aún no está programada."
    # Programar la tarea en crontab para ejecutar este script cada 30 minutos
    echo "*/30 * * * * $HOME/Desktop/REPOS/repomacia/smx_2/Programador_push_automatico.sh" | crontab -
fi

# Definir las variables con la ruta de mi repo y la rama específica donde se va a subir automáticamente.
WORKING_DIR="$HOME/Escritorio/REPOS/repomacia/smx_2"
BRANCH="borja_rama_toco"

# Cambiar al directorio del repo
cd "$WORKING_DIR" || exit

# Realizar un pull para obtener los últimos cambios de la rama remota
git pull origin "$BRANCH"

# Verificar si hay cambios en la rama
if ! git diff-index --quiet HEAD --; then
    echo "No hay cambios para subir."
else
    # Añadir los cambios si los hay de mi rama
    git add .

    # Crear un commit con una marca de tiempo
    git commit -m "Commit automático de Borja $(date)"

    # Realizar el push al repositorio remoto sin solicitar confirmación al usuario
    git push origin "$BRANCH"
fi