FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y install sudo

RUN groupadd -r supersudo && \
  echo "%supersudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/supersudo && \
  useradd -u 1000 -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash hexblade

RUN mkdir -p /opt/hexblade/packages

COPY packages/install-graphics-util.sh /opt/hexblade/packages
RUN sudo -u hexblade /opt/hexblade/packages/install-graphics-util.sh
