FROM hexblade/hexblade-base:dev

COPY src/pack/util/vscode.sh /opt/hexblade/src/pack/util/vscode.sh
RUN DEBIAN_FRONTEND=noninteractive sudo -E /opt/hexblade/src/pack/util/vscode.sh install
RUN code --version