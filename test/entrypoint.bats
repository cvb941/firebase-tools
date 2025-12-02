#!/usr/bin/env bats

PATH="$BATS_TEST_DIRNAME/bin:$PATH"

function setup() {
  # Ensure GITHUB_WORKSPACE is set
  export GITHUB_WORKSPACE="${GITHUB_WORKSPACE-"${BATS_TEST_DIRNAME}/.."}"
}

@test "entrypoint with PROJECT_PATH works" {
  run env FIREBASE_TOKEN=DUMMY_TOKEN FIREBASE_COMMAND="npx" $GITHUB_WORKSPACE/entrypoint.sh target
  echo "$output"
  [ "$status" -ne 0 ]
  [[ "$output" == *"Not in a Firebase app directory"* ]]

  mkdir -p app
  echo "{}" > app/firebase.json

  run env FIREBASE_TOKEN=DUMMY_TOKEN FIREBASE_COMMAND="npx" PROJECT_PATH=app $GITHUB_WORKSPACE/entrypoint.sh target
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "$output" != *"Not in a Firebase app directory"* ]]

  rm -rf app
}
