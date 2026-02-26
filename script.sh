#!/bin/bash
set -e

handleDep() {
  REPO="${1%%@*}"
  TAG="${1#*@}"
  TAG="${TAG%%:*}"
  OVERRIDE_INCLUDE_PATH=$(echo "$1" | grep -Po '(?<=:).+' || true)

  if [ -z "$REPO" ]; then
    echo "No repo provided"
    exit 1
  fi

  INIT_PWD=$(pwd)
  mkdir -p "dep/${REPO}"
  cd "dep/${REPO}"

  if [ -z "$TAG" ]; then
    TAG=$(curl --silent "https://api.github.com/repos/${REPO}/releases/latest" | jq -r .tag_name)
  fi

  wget -q "https://github.com/${REPO}/archive/refs/tags/${TAG}.zip"
  7z x "${TAG}.zip" > /dev/null

  REPO_NAME=$(echo "${REPO}" | grep -Po '(?<=\/).+')
  INCLUDE_PATH="$(pwd)/${REPO_NAME}-${TAG}/${OVERRIDE_INCLUDE_PATH:-amxmodx/scripting/include}"

  echo "-i${INCLUDE_PATH}"

  cd "$INIT_PWD"
}

DEPS_COMPILER_ARGS=""

while IFS= read -r dep; do
  [ -z "$dep" ] && continue
  path_arg=$(handleDep "$dep")
  DEPS_COMPILER_ARGS="${DEPS_COMPILER_ARGS} ${path_arg}"
done <<< "$DEPS_LIST"

echo "Final ${OUTPUT_VAR_NAME}: ${DEPS_COMPILER_ARGS}"
echo "${OUTPUT_VAR_NAME}=${DEPS_COMPILER_ARGS}" >> $GITHUB_ENV