#!/bin/bash

set -eux

COQ_VER="${1:-8.13.0}"

IMAGE=coq-docset-dash-image:"${COQ_VER//+/-}"
CONTAINER=coq-docset-dash-container-"${COQ_VER//+/-}"
TARGET=build/dash-docset-coq-"${COQ_VER//+/-}"

function die(){
  echo "$1"
  exit 1
}

cd "$(dirname $(readlink -f "$0"))" || die "cd failed"
docker build -t "$IMAGE" --build-arg COQ_VER="${COQ_VER}" . || die "building docker image failed"
docker create --name "$CONTAINER" "$IMAGE" /bin/sh || die "creating docker container failed"
mkdir -p "$TARGET" || die "mkdir failed"
docker cp "$CONTAINER":/coq/Coq.docset "$TARGET"/ || die "copying from docker container failed"
docker rm "$CONTAINER" || die "deleting docker container failed"

cat <<JSON > "$TARGET/Coq.docset/meta.json" || die "writing to meta.json failed"
{
  "name": "Coq",
  "revision": "0",
  "title": "Coq",
  "version": "$COQ_VER"
}
JSON

./tools/edit_info_plist.py "$TARGET/Coq.docset/Contents/Info.plist" || die "editing Info.plist failed"
./tools/remove_absent_link.py "$TARGET/Coq.docset" || die "removing absent link from index failed"

echo "Success: docset saved to $TARGET"
echo "Note: this script does not delete docker image"
echo "execute '$ docker rmi $IMAGE' manually"
