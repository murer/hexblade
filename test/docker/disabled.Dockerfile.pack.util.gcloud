FROM hexblade/hexblade-base:dev

COPY src/pack/util/gcloud.sh /opt/hexblade/src/pack/util/gcloud.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/gcloud.sh install
RUN gcloud --version
RUN touch /home/hex/.config/gcloud/checkaccess