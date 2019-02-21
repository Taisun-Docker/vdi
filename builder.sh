#! /bin/bash
DOCKER_TAG=$1
DOCKER_PATH=$2

# Grab the qemu binaries
wget https://s3-us-west-2.amazonaws.com/taisun-builds/qemu/qemu-aarch64-static
wget https://s3-us-west-2.amazonaws.com/taisun-builds/qemu/qemu-arm-static
chmod +x qemu-*
# Build the Ubuntu Bionic against the 3 architectures
docker build --no-cache -f ${DOCKER_PATH}Dockerfile.amd64 -t ${DOCKERHUB_LIVE}:amd64-${TRAVIS_COMMIT}-${DOCKER_TAG} .
docker build --no-cache -f ${DOCKER_PATH}Dockerfile.armhf -t ${DOCKERHUB_LIVE}:arm32v6-${TRAVIS_COMMIT}-${DOCKER_TAG} .
docker build --no-cache -f ${DOCKER_PATH}Dockerfile.aarch64 -t ${DOCKERHUB_LIVE}:arm64v8-${TRAVIS_COMMIT}-${DOCKER_TAG} .
# Tag these builds to latest
docker tag ${DOCKERHUB_LIVE}:amd64-${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:amd64-${DOCKER_TAG}
docker tag ${DOCKERHUB_LIVE}:arm32v6-${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm32v6-${DOCKER_TAG}
docker tag ${DOCKERHUB_LIVE}:arm64v8-${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm64v8-${DOCKER_TAG}
# Login to DockerHub
echo $DOCKERPASS | docker login -u $DOCKERUSER --password-stdin
# Push all of the tags
docker push ${DOCKERHUB_LIVE}:amd64-${TRAVIS_COMMIT}-${DOCKER_TAG}
docker push ${DOCKERHUB_LIVE}:arm32v6-${TRAVIS_COMMIT}-${DOCKER_TAG}
docker push ${DOCKERHUB_LIVE}:arm64v8-${TRAVIS_COMMIT}-${DOCKER_TAG}
docker push ${DOCKERHUB_LIVE}:amd64-${DOCKER_TAG}
docker push ${DOCKERHUB_LIVE}:arm32v6-${DOCKER_TAG}
docker push ${DOCKERHUB_LIVE}:arm64v8-${DOCKER_TAG}
# Generate local manifests for tag and at commit
docker manifest create ${DOCKERHUB_LIVE}:${DOCKER_TAG} ${DOCKERHUB_LIVE}:amd64-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm32v6-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm64v8-${DOCKER_TAG}
docker manifest annotate ${DOCKERHUB_LIVE}:${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm32v6-${DOCKER_TAG} --os linux --arch arm
docker manifest annotate ${DOCKERHUB_LIVE}:${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm64v8-${DOCKER_TAG} --os linux --arch arm64 --variant v8
docker manifest create ${DOCKERHUB_LIVE}:${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:amd64-${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm32v6-${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm64v8-${TRAVIS_COMMIT}-${DOCKER_TAG}
docker manifest annotate ${DOCKERHUB_LIVE}:${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm32v6-${TRAVIS_COMMIT}-${DOCKER_TAG} --os linux --arch arm
docker manifest annotate ${DOCKERHUB_LIVE}:${TRAVIS_COMMIT}-${DOCKER_TAG} ${DOCKERHUB_LIVE}:arm64v8-${TRAVIS_COMMIT}-${DOCKER_TAG} --os linux --arch arm64 --variant v8
# Push the manifests to these meta tags
docker manifest push ${DOCKERHUB_LIVE}:${DOCKER_TAG}
docker manifest push ${DOCKERHUB_LIVE}:${TRAVIS_COMMIT}-${DOCKER_TAG}
