#!/bin/bash -xe

cmd_build() {
  local hextarget="${1?'target, use all to build all'}"
  if [[ "x$hextarget" != "xall" ]]; then
    docker build --target "$hextarget" -t hexblade/hexblade:dev .
  else
    docker build --target mini -t hexblade/hexblade:dev .
    docker build --target firefox -t hexblade/hexblade-firefox:dev .
    docker build --target chrome -t hexblade/hexblade-chrome:dev .
  fi
}

cmd_clean() {
  docker ps -aq --filter label=hexblade_dev | xargs docker rm -f || true
  docker system prune --volumes --filter label=hexblade_dev -f || true
}

cmd_run() {
  docker run -it --rm --label hexblade_dev \
    -p 5900:5900 \
    hexblade/hexblade:dev "$@"
}

cmd_push() {
  hexblade_docker_version="${1?"version to push"}"
  hexblade_docker_alias="${2}"
  docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_version"
  docker tag hexblade/hexblade-firefox:dev "murer/hexblade-firefox:$hexblade_docker_version"
  docker tag hexblade/hexblade-chrome:dev "murer/hexblade-chrome:$hexblade_docker_version"
  docker push "murer/hexblade:$hexblade_docker_version"
  docker push "murer/hexblade-firefox:$hexblade_docker_version"
  docker push "murer/hexblade-chrome:$hexblade_docker_version"
  if [[ "x$hexblade_docker_alias" != "x" ]]; then
    docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_alias"
    docker tag hexblade/hexblade-firefox:dev "murer/hexblade-firefox:$hexblade_docker_alias"
    docker tag hexblade/hexblade-chrome:dev "murer/hexblade-chrome:$hexblade_docker_alias"
    docker push "murer/hexblade:$hexblade_docker_alias"
    docker push "murer/hexblade-firefox:$hexblade_docker_alias"
    docker push "murer/hexblade-chrome:$hexblade_docker_alias"
  fi
}

# cmd_pull() {
#   hexblade_docker_version="${1:-"edge"}"
#   docker pull "murer/hexblade:$hexblade_docker_version"
#   docker tag "murer/hexblade:$hexblade_docker_version" hexblade/hexblade:dev
# }

cmd_login() {
  set +x
  echo "${DOCKER_PASS?'DOCKER_PASS'}" | docker login -u "${DOCKER_USER?'DOCKER_USER'}" --password-stdin
}

cmd_test() {
  local testname="${1?'test to run, like: pack.util.atom'}"
  docker build -t "hexablde/test.$testname:dev" -f "test/docker/Dockerfile.$testname" .
}

cmd_test_all() {
  local k
  find test/docker -maxdepth 1 -type f -name 'Dockerfile.*' | cut -d'/' -f3 | cut -d'.' -f2- | while read k; do
    cmd_test "$k"
  done
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
