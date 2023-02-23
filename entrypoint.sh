#!/bin/sh

set -e

# printenv stops certain abberant behaviors of writing the key, like control characters
printenv INPUT_SERVICE_ACCOUNT_KEY > "$HOME"/gcloud.json

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

gcloud auth configure-docker $INPUT_REGISTRY_SERVER --quiet

docker build -f "$INPUT_DOCKERFILE" -t "$INPUT_IMAGE" $BUILD_ARGS "$INPUT_CONTEXT" $TARGET

echo "Pushing $INPUT_IMAGE"
#docker push $INPUT_IMAGE

if [ "$INPUT_ADDITIONAL_TAG" ]; then   
    tagset=${INPUT_ADDITIONAL_TAG//;/$'\n'} 
    echo "Applying $INPUT_ADDITIONAL_TAG Additional Tag to $INPUT_IMAGE"
    for tag in $tagset
    do
        docker tag $INPUT_IMAGE $INPUT_IMAGE:$TAG
    done
    echo "Pushing $INPUT_IMAGE:$INPUT_ADDITIONAL_TAG"
    #docker push $INPUT_IMAGE:$INPUT_ADDITIONAL_TAG
fi

docker image ls

docker push --all-tags $INPUT_IMAGE
