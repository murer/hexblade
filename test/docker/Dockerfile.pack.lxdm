FROM hexblade/hexblade-base:dev

COPY src/pack/lxdm /opt/hexblade/src/pack/lxdm
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/lxdm/lxdm.sh install
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/lxdm/lxdm.sh autologin hexblade
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/lxdm/lxdm.sh tcplisten enable
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/lxdm/lxdm.sh tcplisten disable