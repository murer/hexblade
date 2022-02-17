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

COPY src/pack/util/tools.sh /opt/hexblade/src/pack/util/tools.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/tools.sh install

COPY src/pack/util/graphics.sh /opt/hexblade/src/pack/util/graphics.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh xterm
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/graphics.sh mousepad

COPY src/pack/lxterminal /opt/hexblade/src/pack/lxterminal
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/lxterminal/lxterminal.sh install

COPY src/pack/openbox /opt/hexblade/src/pack/openbox
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/openbox/openbox.sh install
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/openbox/openbox.sh lockscreen disable

RUN echo 'x11vnc -display :99 -forever -shared -passwd 123 &' | sudo tee /etc/xdg/openbox/autostart.d/80-vnc.sh

COPY . /opt/hexblade
# RUN sudo cp -Rv /opt/hex/docker/etc/xdg /etc

ENV DISPLAY :99
EXPOSE 5900

ENTRYPOINT [ "/opt/hexblade/docker/entrypoint.sh" ]

CMD  [ "hexbladestart" ]