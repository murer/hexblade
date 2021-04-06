#!/bin/bash -xe

install() {
	filename="$1"
	dirname="$2"
	if [ ! -f "$filename" ]; then
	        wget --progress=dot -e dotbytes=1M "https://storage.googleapis.com/dxtpub/repoz/r/pub/jdk/oracle/$filename"
	fi
	rm -rf "$dirname" | cat
	tar xzf "$filename"
}

cmd_install() {
	cd /opt

	install jdk-8u221-linux-x64.tar.gz jdk1.8.0_221
	install jdk-7u67-linux-x64.tar.gz jdk1.7.0_67
	install jdk1.6.0_45.tar.gz jdk1.6.0_45

	if [ ! -L jdk ]; then
		ln -s jdk1.7.0_67 jdk;
	else
		echo 'jdk link already exists. Maybe you want to change it';
	fi;

	if ! grep "bash.bashrc.jdk" /etc/bash.bashrc; then
		tee /etc/bash.bashrc.jdk <<-EOF
		export JAVA_HOME=/opt/jdk
		export PATH=/bin:\$JAVA_HOME/bin:\$PATH
		EOF
		echo "# bash.bashrc.jdk" | tee -a /etc/bash.bashrc
		echo "source /etc/bash.bashrc.jdk" | tee -a /etc/bash.bashrc
	fi

	cd -
}

cd "$(dirname "$0")"; _cmd="${1?"cmd is required"}"; shift; "cmd_${_cmd}" "$@"
