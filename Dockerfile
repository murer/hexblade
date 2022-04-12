FROM ubuntu:20.04

RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ca-certificates
# COPY src/lib/basesys/etc/apt/sources.list /etc/apt/sources.list
# RUN apt-get -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install sudo
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install xvfb
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install x11vnc

RUN groupadd -r supersudo && \
  echo "%supersudo ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/supersudo && \
  useradd -r -m -G adm,cdrom,sudo,supersudo,dip,plugdev -s /bin/bash hex

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

RUN find "$HOME" -readable -exec chmod -v go+r '{}' \; && \
  find "$HOME" -writable -exec chmod -v go+w '{}' \; && \
  find "$HOME" -executable -exec chmod -v go+x '{}' \;

ENV DISPLAY :99
EXPOSE 5900

ENTRYPOINT [ "/opt/hexblade/docker/entrypoint/entrypoint.sh" ]

COPY docker/entrypoint /opt/hexblade/docker/entrypoint

CMD [ "hexbladestart" ]

# FROM chrome AS puppeteer

# SHELL [ "/bin/bash", "-ec" ]
# COPY src/pack/util/nvm.sh /opt/hexblade/src/pack/util/nvm.sh
# RUN DEBIAN_FRONTEND=noninteractive /opt/hexblade/src/pack/util/nvm.sh install
# ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/google-chrome
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
# RUN mkdir /home/hex/workspace
# WORKDIR /home/hex/workspace
# RUN export NVM_HOME=/home/hex/.nvm && \
#   source "$NVM_HOME/nvm.sh" && \
#   source "$NVM_HOME/bash_completion" && \
#   nvm install --lts && \
#   npm install puppeteer
  
# COPY src/pack/util/node.sh /opt/hexblade/src/pack/util/node.sh
# RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/node.sh install
# ENV PUPPETEER_EXECUTABLE_PATH /usr/bin/google-chrome
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
# RUN sudo -E npm install -g puppeteer 
# COPY . /opt/hexblade


