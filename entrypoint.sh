#!/bin/sh

set -e

# printenv stops certain abberant behaviors of writing the key, like control characters
printenv INPUT_SERVICE_ACCOUNT_KEY > "$HOME"/gcloud.json

cat "$HOME"/gcloud.json

ls /github
ls /github/workspace

if [ -z "$INPUT_CONTEXT" ]; then
    INPUT_CONTEXT="."
fi

if [ "$INPUT_TARGET" ]; then
    TARGET="--target ${INPUT_TARGET}"
fi

if [ "$INPUT_BUILD_ARGS" ]; then
    BUILD_ARGS_SPLIT=$(echo "$INPUT_BUILD_ARGS" | tr ',' '\n')
    BUILD_ARGS="--build-arg $(echo $BUILD_ARGS_SPLIT | xargs | sed 's/ / --build-arg /g')"
fi

gcloud auth activate-service-account --key-file="$HOME"/gcloud.json --project "$INPUT_PROJECT_ID"

gcloud auth configure-docker us-east4-docker.pkg.dev

gcloud artifacts locations list

docker build -f "$INPUT_DOCKERFILE" -t "$INPUT_IMAGE" $BUILD_ARGS "$INPUT_CONTEXT" $TARGET

docker push $INPUT_IMAGE
