FROM hexblade/hexblade-base:dev

COPY src/hexes/util/reuser.sh /opt/hexblade/src/hexes/util/reuser.sh
RUN sudo mkdir /localdata
RUN sudo /opt/hexblade/src/hexes/util/reuser.sh redir /home
RUN bash -xec '[[ -d /localdata/hexes/redir/root/L2hvbWU/hex ]]'
RUN (echo "#!/bin/bash -xe" && \
    echo "sudo /opt/hexblade/src/hexes/util/reuser.sh adduser t1" && \
    echo "sudo /opt/hexblade/src/hexes/util/reuser.sh reuser t1 whoami | grep '^t1$'") | \
    /opt/hexblade/docker/entrypoint.sh bash -xe