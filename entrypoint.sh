#!/bin/bash

set -e

if [ -n "$INPUT_FIREBASE_TOKEN" ]; then
  FIREBASE_TOKEN=$INPUT_FIREBASE_TOKEN
fi

if [ -n "$INPUT_GCP_SA_KEY" ]; then
  GCP_SA_KEY=$INPUT_GCP_SA_KEY
fi

if [ -z "$FIREBASE_TOKEN" ] && [ -z "$GCP_SA_KEY" ]; then
  echo "Either FIREBASE_TOKEN or GCP_SA_KEY is required to run commands with the firebase cli"
  exit 126
fi

if [ -n "$GCP_SA_KEY" ]; then
  GCP_SA_KEY_PATH="/tmp/gcp_key.json"
  echo "Storing GCP_SA_KEY in $GCP_SA_KEY_PATH"
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "$GCP_SA_KEY" | base64 -D > "$GCP_SA_KEY_PATH"
  else
    echo "$GCP_SA_KEY" | base64 -d > "$GCP_SA_KEY_PATH"
  fi
  echo "Exporting GOOGLE_APPLICATION_CREDENTIALS=$GCP_SA_KEY_PATH"
  export GOOGLE_APPLICATION_CREDENTIALS="$GCP_SA_KEY_PATH"
fi

if [ -n "$PROJECT_PATH" ]; then
  cd "$PROJECT_PATH"
fi

if [ -n "$PROJECT_ID" ]; then
    echo "setting firebase project to $PROJECT_ID"
    npx firebase-tools@14.26.0 use --add "$PROJECT_ID"
fi

# if the args starts with ./ we are running a script
case "$*" in
  ./*) sh -c "$*";;
  *) sh -c "npx firebase-tools@14.26.0 $*";;
esac
