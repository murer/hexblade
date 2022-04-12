#!/bin/bash -xe

function cmd_build() {
  local hextarget="${1?'target, use base, mini or all'}"
  docker build --cache-from hexblade/hexblade-base:dev -t hexblade/hexblade-base:dev .
  if [[ "x$hextarget" == "xbase" ]]; then return; fi
  docker build --cache-from hexblade/hexblade:dev -t hexblade/hexblade:dev -f docker/util/Dockerfile.mini .
  if [[ "x$hextarget" == "xmini" ]]; then return; fi
  docker build --cache-from hexblade/hexblade-firefox:dev -t hexblade/hexblade-firefox:dev -f docker/util/Dockerfile.firefox .
  docker build --cache-from hexblade/hexblade-basechrome:dev -t hexblade/hexblade-basechrome:dev -f docker/util/Dockerfile.basechrome .
  docker build --cache-from hexblade/hexblade-chrome:dev -t hexblade/hexblade-chrome:dev -f docker/util/Dockerfile.chrome .
  docker build --cache-from hexblade/hexblade-puppeteer:dev -t hexblade/hexblade-puppeteer:dev -f docker/puppeteer/Dockerfile.puppeteer .
}

function cmd_export() {
  rm -rf target/wp-docker/docker || true
  mkdir -p target/wp-docker/docker
  docker save \
    hexblade/hexblade-base:dev \
    hexblade/hexblade:dev \
    hexblade/hexblade-firefox:dev \
    hexblade/hexblade-chrome:dev | \
      gzip > target/wp-docker/docker/docker-hexblade.tar.gz
  du -hs target/wp-docker/docker/*
}

function cmd_import() {
  du -hs target/wp-docker/docker/*
  docker load -i target/wp-docker/docker/docker-hexblade.tar.gz
}

function cmd_clean() {
  docker ps -aq --filter label=hexblade_dev | xargs docker rm -f || true
  docker system prune --volumes --filter label=hexblade_dev -f || true
}

function cmd_run() {
  docker run -it --rm --label hexblade_dev \
    -p 5900:5900 \
    hexblade/hexblade:dev "$@"
}

function cmd_push() {
  hexblade_docker_version="${1?"version to push"}"
  hexblade_docker_alias="${2}"
  docker tag hexblade/hexblade-base:dev "murer/hexblade-base:$hexblade_docker_version"
  docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_version"
  docker tag hexblade/hexblade-firefox:dev "murer/hexblade-firefox:$hexblade_docker_version"
  docker tag hexblade/hexblade-chrome:dev "murer/hexblade-chrome:$hexblade_docker_version"
  docker push "murer/hexblade-base:$hexblade_docker_version"
  docker push "murer/hexblade:$hexblade_docker_version"
  docker push "murer/hexblade-firefox:$hexblade_docker_version"
  docker push "murer/hexblade-chrome:$hexblade_docker_version"
  if [[ "x$hexblade_docker_alias" != "x" ]]; then
    docker tag hexblade/hexblade-base:dev "murer/hexblade-base:$hexblade_docker_alias"
    docker tag hexblade/hexblade:dev "murer/hexblade:$hexblade_docker_alias"
    docker tag hexblade/hexblade-firefox:dev "murer/hexblade-firefox:$hexblade_docker_alias"
    docker tag hexblade/hexblade-chrome:dev "murer/hexblade-chrome:$hexblade_docker_alias"
    docker push "murer/hexblade-base:$hexblade_docker_alias"
    docker push "murer/hexblade:$hexblade_docker_alias"
    docker push "murer/hexblade-firefox:$hexblade_docker_alias"
    docker push "murer/hexblade-chrome:$hexblade_docker_alias"
  fi
}

cmd_pull() {
  hexblade_docker_version="${1:-"edge"}"
  docker pull "murer/hexblade-base:$hexblade_docker_version"
  docker pull "murer/hexblade:$hexblade_docker_version"
  docker pull "murer/hexblade-firefox:$hexblade_docker_version"
  docker pull "murer/hexblade-chrome:$hexblade_docker_version"
  docker tag "murer/hexblade-base:$hexblade_docker_version" hexblade/hexblade-base:dev
  docker tag "murer/hexblade:$hexblade_docker_version" hexblade/hexblade:dev
  docker tag "murer/hexblade-firefox:$hexblade_docker_version" hexblade/hexblade-firefox:dev
  docker tag "murer/hexblade-chrome:$hexblade_docker_version" hexblade/hexblade-chrome:dev
}

function cmd_login() {
  set +x
  echo "${DOCKER_PASS?'DOCKER_PASS'}" | docker login -u "${DOCKER_USER?'DOCKER_USER'}" --password-stdin
}

function cmd_test() {
  local testname="${1?'test to run, like: pack.util.atom'}"
  docker build -t "hexablde/test.$testname:dev" -f "test/docker/Dockerfile.$testname" .
}

function cmd_test_all() {
  local k
  find test/docker -maxdepth 1 -type f -name 'Dockerfile.*' | cut -d'/' -f3 | cut -d'.' -f2- | while read k; do
    cmd_test "$k"
  done
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
