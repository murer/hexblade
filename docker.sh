#!/bin/bash -xe

cmd_build() {
  docker build -t hexblade/hexblade:dev .
}

cmd_clean() {
  docker ps -aq --filter label=hexblade_dev | xargs docker rm -f || true
  docker system prune --volumes --filter label=hexblade_dev -f || true
}

cmd_run() {
  docker run -it --rm --label hexblade_dev \
    -p 5900:5900 \
    hexblade/hexblade:dev
}

cmd_push() {
  hexblade_docker_version="${1?"version to push"}"
  docker tag hexblade/hexblade:dev "murer/lhproxy:$hexblade_docker_version"
  docker push "hexblade/hexblade:dev:$hexblade_docker_version"
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
