FROM hexblade/hexblade-base:dev

COPY src/pack/util/chrome.sh /opt/hexblade/src/pack/util/chrome.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/chrome.sh install
RUN google-chrome --version