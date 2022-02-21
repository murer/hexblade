FROM hexblade/hexblade-base:dev

COPY src/pack/util/atom.sh /opt/hexblade/src/pack/util/atom.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/atom.sh install
RUN atom --no-sandbox --version