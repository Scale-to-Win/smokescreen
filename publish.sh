#!/bin/bash

set -euo pipefail

export NEW_TAG="$(date +%Y-%m-%d)"
echo "Building smokescreen image with tag $NEW_TAG"

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

docker buildx build --platform=linux/amd64 -t public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-linux-amd64 .
docker push public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-linux-amd64
docker build -t public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-darwin-arm64 .
docker push public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-darwin-arm64
docker manifest create public.ecr.aws/scaletowin/smokescreen:$NEW_TAG public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-linux-amd64 public.ecr.aws/scaletowin/smokescreen:$NEW_TAG-darwin-arm64
docker manifest push public.ecr.aws/scaletowin/smokescreen:$NEW_TAG
