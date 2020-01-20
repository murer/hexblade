#!/bin/bash -xe 

cd /opt
if [ ! -f apache-maven-3.3.9-bin.tar.gz ]; then
	sudo wget 'https://repoz.dextra.com.br/repoz/r/pub/maven/apache-maven-3.3.9-bin.tar.gz'
fi
sudo rm -rf apache-maven-3.3.9 | cat
sudo tar xzf apache-maven-3.3.9-bin.tar.gz
if [ ! -L maven ]; then
	sudo ln -s apache-maven-3.3.9 maven;
else
	echo 'maven link already exists. Maybe you want to change it';
fi;

if ! grep "bash.bashrc.maven" /etc/bash.bashrc; then
	sudo tee /etc/bash.bashrc.maven <<-EOF
	export MAVEN_HOME=/opt/maven
	export PATH=\$MAVEN_HOME/bin:\$PATH
	EOF
	echo "# bash.bashrc.maven" | sudo tee -a /etc/bash.bashrc
	echo "source /etc/bash.bashrc.maven" | sudo tee -a /etc/bash.bashrc
fi

source /etc/bash.bashrc.maven
cd -
