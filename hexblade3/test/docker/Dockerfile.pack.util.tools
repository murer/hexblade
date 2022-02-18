FROM hexblade/hexblade-base:dev

COPY src/pack/util/tools.sh /opt/hexblade/src/pack/util/tools.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/tools.sh install
RUN ncat --version