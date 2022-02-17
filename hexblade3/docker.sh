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

# cmd_push() {
#   hexblade_docker_version="${1?"version to push"}"
#   hexblade_docker_alias="${2}"
#   docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_version"
#   docker push "murer/hexblade:$hexblade_docker_version"
#   if [[ "x$hexblade_docker_alias" != "x" ]]; then
#     docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_alias"
#     docker push "murer/hexblade:$hexblade_docker_alias"
#   fi
# }

# cmd_pull() {
#   hexblade_docker_version="${1:-"edge"}"
#   docker pull "murer/hexblade:$hexblade_docker_version"
#   docker tag "murer/hexblade:$hexblade_docker_version" hexblade/hexblade:dev
# }

# cmd_login() {
#   set +x
#   echo "${DOCKER_PASS?'DOCKER_PASS'}" | docker login -u "${DOCKER_USER?'DOCKER_USER'}" --password-stdin
# }

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
