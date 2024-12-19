#!/bin/bash

# Parámetros
EXECUTOR=$1
MOTIVO=$2
BRANCH="ci_jenkins"

# Mensaje de commit
COMMIT_MSG="Actualización automática del README.md por ${EXECUTOR}. Motivo: ${MOTIVO}"

# Configuración de Git
echo "Configurando Git..."
git config --global user.name "${EXECUTOR}"
git config --global user.email "jenkins@pipeline.local"

# Añadir y commitear los cambios
echo "Añadiendo y commiteando cambios..."
git add README.md
git commit -m "${COMMIT_MSG}" || echo "No hay cambios para commitear."

# Hacer push con rebase en caso de conflictos
echo "Haciendo push de los cambios al repositorio remoto..."
git pull --rebase origin ${BRANCH}
git push origin HEAD:${BRANCH} || {
     echo "El push falló. Intentando resolver conflictos..."
     git pull --rebase origin ${BRANCH}
     git push origin HEAD:${BRANCH} || {
          echo "Error: No se pudo realizar el push tras múltiples intentos."
          exit 1
     }
}

echo "Push completado con éxito."
exit 0
