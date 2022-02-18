FROM hexblade/hexblade-base:dev

COPY src/pack/util/gh.sh /opt/hexblade/src/pack/util/gh.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/gh.sh install
RUN gh --version