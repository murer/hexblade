#!/bin/bash -e

install() {
	filename=$1
	dirname=$2
	if [ ! -f $filename ]; then
	        sudo wget "http://repoz.dextra.com.br/repoz/r/pub/jdk/oracle/$filename"
	fi
	sudo rm -rf $dirname | cat
	sudo tar xzvf $filename
}

cd /opt

install jdk-8u221-linux-x64.tar.gz jdk1.8.0_221
install jdk-7u67-linux-x64.tar.gz jdk1.7.0_67
install jdk1.6.0_45.tar.gz jdk1.6.0_45

if [ ! -L jdk ]; then
	sudo ln -s jdk1.7.0_67 jdk;
else
	echo 'jdk link already exists. Maybe you want to change it';
fi;

if ! grep "bash.bashrc.jdk" /etc/bash.bashrc; then
	sudo tee /etc/bash.bashrc.jdk <<-EOF
	export JAVA_HOME=/opt/jdk
	export PATH=\$JAVA_HOME/bin:\$PATH
	EOF
	echo "# bash.bashrc.jdk" | sudo tee -a /etc/bash.bashrc
	echo "source /etc/bash.bashrc.jdk" | sudo tee -a /etc/bash.bashrc
fi

source /etc/bash.bashrc.jdk

cd -
