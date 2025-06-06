#!/bin/bash

# Asegúrate de que las variables de entorno están disponibles
if [ -z "$TRELLO_API_KEY" ] || [ -z "$TRELLO_TOKEN" ]; then
  echo "Error: TRELLO_API_KEY o TRELLO_TOKEN no están configuradas."
  exit 1
fi

# Variables de CircleCI (disponibles automáticamente)
COMMIT_MESSAGE=$(git log -1 --pretty=%B) # Mensaje del último commit
COMMIT_SHA=$CIRCLE_SHA1                  # SHA del commit
REPO_URL=$CIRCLE_REPOSITORY_URL          # URL del repositorio
BUILD_URL=$CIRCLE_BUILD_URL              # URL del build de CircleCI
BRANCH=$CIRCLE_BRANCH                    # Rama del commit

# ID de la tarjeta de Trello que quieres actualizar
# Puedes obtener este ID de la URL de la tarjeta en Trello.
# Por ejemplo, si tu URL es https://trello.com/c/ABCDE123/titulo-tarjeta
# el ID de la tarjeta es ABCDE123
TRELLO_CARD_ID="TU_ID_DE_TARJETA_TRELLO" # ¡IMPORTANTE: Reemplaza esto!

# El contenido del comentario que añadirás a la tarjeta
COMMENT="Nuevo commit en la rama *$BRANCH*:
Mensaje: \`$COMMIT_MESSAGE\`
SHA: \`$COMMIT_SHA\`
Build de CircleCI: $BUILD_URL
Repositorio: $REPO_URL"

echo "Intentando actualizar la tarjeta de Trello con ID: $TRELLO_CARD_ID"
echo "Comentario: $COMMENT"

# Realizar la llamada a la API de Trello para añadir un comentario
curl --request POST \
  --url "https://api.trello.com/1/cards/$TRELLO_CARD_ID/actions/comments?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{
    \"text\": \"$COMMENT\"
  }"

if [ $? -eq 0 ]; then
  echo "Tarjeta de Trello actualizada con éxito."
else
  echo "Error al actualizar la tarjeta de Trello."
  exit 1
fi