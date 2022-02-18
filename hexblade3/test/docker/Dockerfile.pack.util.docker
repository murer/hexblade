FROM hexblade/hexblade-base:dev

COPY src/pack/util/docker.sh /opt/hexblade/src/pack/util/docker.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/docker.sh install
RUN groups | grep docker
RUN docker --version