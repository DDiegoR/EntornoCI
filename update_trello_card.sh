#!/bin/bash

if [ -z "$TRELLO_API_KEY" ] || [ -z "$TRELLO_TOKEN" ]; then
  echo "Error: TRELLO_API_KEY o TRELLO_TOKEN no están configuradas."
  exit 1
fi

COMMIT_MSG=$(git log -1 --pretty=%B)
    echo "Último commit: $COMMIT_MSG"
# Busca ID de tarjeta
CARD_ID=$(echo "$COMMIT_MSG" | grep -oE 'TRELLO-[a-zA-Z0-9]+')
if [ -n "$CARD_ID" ]; then
    echo "ID de tarjeta encontrado: $CARD_ID"
    TRELLO_CARD_ID="${CARD_ID#TRELLO-}"
fi

# ID de la lista de completados
TRELLO_COMPLETED_LIST_ID="684203e2005b352a3c6dccaf"

# URL del build de CircleCI
BUILD_URL=$CIRCLE_BUILD_URL              

echo "ID de tarjeta de Trello extraída para usar: $TRELLO_CARD_ID" 
echo "Intentando mover la tarjeta de Trello con ID: $TRELLO_CARD_ID"

# Llamada a la API de Trello - Update a Card
curl --request PUT \
  --url "https://api.trello.com/1/cards/$TRELLO_CARD_ID?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data "{
    \"idList\": \"$TRELLO_COMPLETED_LIST_ID\"
  }"

if [ $? -eq 0 ]; then
  echo "Tarjeta de Trello movida con éxito a la lista de Hecho."
  COMMENT="Tarjeta movida a 'Hecho' por un commit en CircleCI.
  Mensaje del commit: $COMMIT_MSG
  Build: $BUILD_URL"

  curl --request POST \
    --url "https://api.trello.com/1/cards/$TRELLO_CARD_ID/actions/comments?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data "$(jq -n --arg text "$COMMENT" '{text: $text}')"
  if [ $? -eq 0 ]; then
    echo "Comentario añadido a la tarjeta movida."
  else
    echo "Error al añadir comentario a la tarjeta movida."
  fi

else
  echo "Error al mover la tarjeta de Trello."
  exit 1
fi