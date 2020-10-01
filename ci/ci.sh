#!/bin/bash -xe

export DEBIAN_FRONTEND="noninteractive"

cmd_before_install() {
  sudo -E cmds/installer-prepare.sh
}

cmd_config_params() {
  echo "us"
  echo "n"
  echo ""
  echo ""
  echo "hexblade"
  echo "ubuntu"
  echo "hexblade"
  echo "hexblade"
}

cmd_script() {
  ./build.sh clean
  cmd_config_params | cmds/config.sh all
  ./docker.sh build

  #./build.sh build_live_text
  ./build.sh build_live_standard
  ./build.sh build_checksum
}

cmd_docker_deploy() {
  hexblade_docker_image_version="${TRAVIS_TAG?'TRAVIS_TAG is required'}"
  set +x
  docker login --username "$DOCKERHUB_USER" --password "$DOCKERHUB_PASS"
  set -x
  ./docker.sh push "$hexblade_docker_image_version"
}

cd "$(dirname "$0")/.."; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
