#!/bin/bash

# Asegúrate de que las variables de entorno están disponibles
if [ -z "$TRELLO_API_KEY" ] || [ -z "$TRELLO_TOKEN" ]; then
  echo "Error: TRELLO_API_KEY o TRELLO_TOKEN no están configuradas."
  exit 1
fi

COMMIT_MSG=$(git log -1 --pretty=%B)
    echo "Último commit: $COMMIT_MSG"
# Buscar ID de tarjeta (ej: TRELLO-abc123)
CARD_ID=$(echo "$COMMIT_MSG" | grep -oE 'TRELLO-[a-zA-Z0-9]+')
if [ -n "$CARD_ID" ]; then
    echo "Encontrado ID de tarjeta: $CARD_ID"
    TRELLO_CARD_ID=$CARD_ID

# Buscar la tarjeta real en Trello por nombre corto (necesita ajustes si hay múltiples)

#CARD_JSON=$(curl -s \
#"https://api.trello.com/1/search?query=$CARD_ID&key=$TRELLO_API_KEY&token=$TRELLO_TOKEN&modelTypes=cards&cards_limit=1")


# ID de la tarjeta de Trello que quieres mover
# Puedes obtener este ID de la URL de la tarjeta en Trello.
# Por ejemplo, si tu URL es https://trello.com/c/ABCDE123/titulo-tarjeta
# el ID de la tarjeta es ABCDE123
#
# ¡IMPORTANTE: Reemplaza "TU_ID_DE_TARJETA_TRELLO" con el ID de la tarjeta que quieres mover!
#TRELLO_CARD_ID=$CARD_ID

# ID de la lista "Completados" (o la lista a la que quieres mover la tarjeta)
# Para obtener el ID de una lista:
# 1. Ve a tu tablero de Trello en el navegador.
# 2. Añade ".json" al final de la URL del tablero (ej: https://trello.com/b/ABCDE123/nombre-tablero.json).
# 3. Busca el nombre de tu lista "Completados" (o el que uses) y ahí encontrarás su "id".
#
# ¡IMPORTANTE: Reemplaza "TU_ID_DE_LISTA_COMPLETADOS" con el ID de tu lista de completados!
TRELLO_COMPLETED_LIST_ID="684203e2005b352a3c6dccaf"

# Variables de CircleCI para el mensaje (opcional, pero útil para contextualizar)
BUILD_URL=$CIRCLE_BUILD_URL              # URL del build de CircleCI

echo "Intentando mover la tarjeta de Trello con ID: $TRELLO_CARD_ID"
echo "A la lista con ID: $TRELLO_COMPLETED_LIST_ID"

# Realizar la llamada a la API de Trello para mover la tarjeta a una nueva lista
curl --request PUT \
  --url "https://api.trello.com/1/cards/$TRELLO_CARD_ID?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{
    \"idList\": \"$TRELLO_COMPLETED_LIST_ID\"
  }"

if [ $? -eq 0 ]; then
  echo "Tarjeta de Trello movida con éxito a la lista de completados."
  # Opcional: Añadir un comentario a la tarjeta después de moverla
  # Esto es útil para dejar un rastro de por qué se movió la tarjeta.
  COMMENT="Tarjeta movida a 'Completados' por un commit en CircleCI.
  Mensaje del commit: \`$COMMIT_MSG\`
  Build: $BUILD_URL"

  curl --request POST \
    --url "https://api.trello.com/1/cards/$TRELLO_CARD_ID/actions/comments?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data "{
      \"text\": \"$COMMENT\"
    }"
  if [ $? -eq 0 ]; then
    echo "Comentario añadido a la tarjeta movida."
  else
    echo "Error al añadir comentario a la tarjeta movida."
  fi

else
  echo "Error al mover la tarjeta de Trello."
  exit 1
fi