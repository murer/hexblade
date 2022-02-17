FROM ubuntu:20.04

RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install xvfb
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install x11vnc

RUN groupadd -r supersudo && \
  echo "%supersudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/supersudo && \
  useradd -u 1000 -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash hex

RUN mkdir -p /opt/hex/packages

USER hex
ENV HOME /home/hex
ENV USER hex
WORKDIR /home/hex

COPY . /opt/hexblade
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/tools.sh install

# COPY packages/graphics /opt/hex/packages/graphics
# RUN sudo -E /opt/hex/packages/graphics/graphics.sh xterm
# RUN sudo -E /opt/hex/packages/graphics/graphics.sh mousepad

# COPY packages/lxterminal /opt/hex/packages/lxterminal
# RUN sudo -E /opt/hex/packages/lxterminal/lxterminal.sh install

# COPY packages/openbox /opt/hex/packages/openbox
# RUN sudo -E /opt/hex/packages/openbox/openbox.sh install
# RUN sudo -E /opt/hex/packages/openbox/openbox.sh lockscreen disable

# COPY . /opt/hex
# RUN sudo cp -Rv /opt/hex/docker/etc/xdg /etc

ENV DISPLAY :99
EXPOSE 5900

CMD "/opt/hex/docker/entrypoint.sh"
