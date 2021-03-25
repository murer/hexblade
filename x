digraph "desktop-base" {
	rankdir=LR;
	node [shape=box];
	"desktop-base" -> "librsvg2-common" [color=blue];
	"librsvg2-common" -> "librsvg2-2" [color=blue,label="(= 2.48.9-1ubuntu0.20.04.1)"];
	"librsvg2-2" -> "libcairo-gobject2" [color=blue,label="(>= 1.10.0)"];
	"libcairo-gobject2" -> "libcairo2" [color=blue,label="(>= 1.10.0)"];
	"libcairo2" -> "libfontconfig1" [color=blue,label="(>= 2.12.6)"];
	"libcairo2" -> "libfreetype6" [color=blue,label="(>= 2.9.1)"];
	"libfreetype6" -> "libpng16-16" [color=blue,label="(>= 1.6.2-1)"];
	"libcairo2" -> "libpixman-1-0" [color=blue,label="(>= 0.30.0)"];
	"libcairo2" -> "libpng16-16" [color=blue,label="(>= 1.6.2-1)"];
	"libcairo2" -> "libxcb-render0" [color=blue];
	"libxcb-render0" -> "libxcb1" [color=blue,label="(>= 1.8)"];
	"libxcb1" -> "libxau6" [color=blue];
	"libxcb1" -> "libxdmcp6" [color=blue];
	"libxdmcp6" -> "libbsd0" [color=blue,label="(>= 0.2.0)"];
	"libcairo2" -> "libxcb-shm0" [color=blue];
	"libxcb-shm0" -> "libxcb1" [color=blue,label="(>= 1.12)"];
	"libcairo2" -> "libxcb1" [color=blue,label="(>= 1.6)"];
	"libcairo2" -> "libxext6" [color=blue];
	"libcairo2" -> "libxrender1" [color=blue];
	"libcairo-gobject2" -> "libglib2.0-0" [color=blue,label="(>= 2.14.0)"];
	"librsvg2-2" -> "libcairo2" [color=blue,label="(>= 1.15.12)"];
	"librsvg2-2" -> "libgcc-s1" [color=blue,label="(>= 4.2)"];
	"libgcc-s1" -> "gcc-10-base" [color=blue,label="(= 10.2.0-5ubuntu1~20.04)"];
	"librsvg2-2" -> "libgdk-pixbuf2.0-0" [color=blue,label="(>= 2.27.1)"];
	"libgdk-pixbuf2.0-0" -> "libglib2.0-0" [color=blue,label="(>= 2.48.0)"];
	"libgdk-pixbuf2.0-0" -> "libjpeg8" [color=blue,label="(>= 8c)"];
	"libjpeg8" -> "libjpeg-turbo8" [color=blue,label="(>= 1.1.90+svn722-1ubuntu6)"];
	"libgdk-pixbuf2.0-0" -> "libpng16-16" [color=blue,label="(>= 1.6.2-1)"];
	"libgdk-pixbuf2.0-0" -> "libtiff5" [color=blue,label="(>= 4.0.3)"];
	"libtiff5" -> "libjbig0" [color=blue,label="(>= 2.0)"];
	"libtiff5" -> "libjpeg8" [color=blue,label="(>= 8c)"];
	"libtiff5" -> "liblzma5" [color=blue,label="(>= 5.1.1alpha+20120614)"];
	"libtiff5" -> "libwebp6" [color=blue,label="(>= 0.5.1)"];
	"libtiff5" -> "libzstd1" [color=blue,label="(>= 1.3.2)"];
	"libgdk-pixbuf2.0-0" -> "shared-mime-info" [color=blue];
	"shared-mime-info" -> "libglib2.0-0" [color=blue,label="(>= 2.35.9)"];
	"shared-mime-info" -> "libxml2" [color=blue,label="(>= 2.7.4)"];
	"libxml2" -> "libicu66" [color=blue,label="(>= 66.1-1~)"];
	"libicu66" -> "libgcc-s1" [color=blue,label="(>= 3.0)"];
	"libicu66" -> "tzdata" [color=blue,label="(>> 2019c-3ubuntu1~)"];
	"tzdata" -> "alt1":"debconf" [color=blue,label="(>= 0.5)"];
	"alt1":"debconf-2.0" -> virt1 [dir=back,arrowtail=inv,color=green];
	"libxml2" -> "liblzma5" [color=blue,label="(>= 5.1.1alpha+20120614)"];
	"libgdk-pixbuf2.0-0" -> "libgdk-pixbuf2.0-common" [color=blue,label="(= 2.40.0+dfsg-3ubuntu0.2)"];
	"libgdk-pixbuf2.0-0" -> "libgdk-pixbuf2.0-bin";
	"libgdk-pixbuf2.0-bin" -> "libgdk-pixbuf2.0-0" [color=blue,label="(>= 2.35.4)"];
	"libgdk-pixbuf2.0-bin" -> "libglib2.0-0" [color=blue,label="(>= 2.48.0)"];
	"librsvg2-2" -> "libglib2.0-0" [color=blue,label="(>= 2.50.0)"];
	"librsvg2-2" -> "libpango-1.0-0" [color=blue,label="(>= 1.38.0)"];
	"libpango-1.0-0" -> "fontconfig" [color=blue,label="(>= 2.1.91)"];
	"libpango-1.0-0" -> "libfribidi0" [color=blue,label="(>= 1.0.0)"];
	"libpango-1.0-0" -> "libglib2.0-0" [color=blue,label="(>= 2.59.2)"];
	"libpango-1.0-0" -> "libharfbuzz0b" [color=blue,label="(>= 2.1.1)"];
	"libharfbuzz0b" -> "libfreetype6" [color=blue,label="(>= 2.9.1)"];
	"libharfbuzz0b" -> "libglib2.0-0" [color=blue,label="(>= 2.31.8)"];
	"libharfbuzz0b" -> "libgraphite2-3" [color=blue,label="(>= 1.2.2)"];
	"libharfbuzz0b" -> "libharfbuzz0" [color=red];
	"libharfbuzz0b" -> "libharfbuzz0a" [color=red];
	"libpango-1.0-0" -> "libthai0" [color=blue,label="(>= 0.1.25)"];
	"libthai0" -> "libthai-data" [color=blue,label="(>= 0.1.10)"];
	"libthai0" -> "libdatrie1" [color=blue,label="(>= 0.2.0)"];
	"librsvg2-2" -> "libpangocairo-1.0-0" [color=blue,label="(>= 1.38.0)"];
	"libpangocairo-1.0-0" -> "libcairo2" [color=blue,label="(>= 1.12.10)"];
	"libpangocairo-1.0-0" -> "libfontconfig1" [color=blue,label="(>= 2.12.6)"];
	"libpangocairo-1.0-0" -> "libglib2.0-0" [color=blue,label="(>= 2.59.2)"];
	"libpangocairo-1.0-0" -> "libpango-1.0-0" [color=blue,label="(= 1.44.7-2ubuntu4)"];
	"libpangocairo-1.0-0" -> "libpangoft2-1.0-0" [color=blue,label="(= 1.44.7-2ubuntu4)"];
	"libpangoft2-1.0-0" -> "libfontconfig1" [color=blue,label="(>= 2.13.0)"];
	"libpangoft2-1.0-0" -> "libfreetype6" [color=blue,label="(>= 2.2.1)"];
	"libpangoft2-1.0-0" -> "libglib2.0-0" [color=blue,label="(>= 2.59.2)"];
	"libpangoft2-1.0-0" -> "libharfbuzz0b" [color=blue,label="(>= 2.6.0)"];
	"libpangoft2-1.0-0" -> "libpango-1.0-0" [color=blue,label="(= 1.44.7-2ubuntu4)"];
	"librsvg2-2" -> "libxml2" [color=blue,label="(>= 2.9.0)"];
	"librsvg2-2" -> "librsvg2-common";
	"librsvg2-common" -> "libgdk-pixbuf2.0-0" [color=blue,label="(>= 2.23.5-2)"];
	"librsvg2-common" -> "libglib2.0-0" [color=blue,label="(>= 2.50.0)"];
	"desktop-base" -> "fonts-quicksand" [color=blue];
	"desktop-base" -> "plymouth-label";
	"plymouth-label" -> "plymouth" [color=blue,label="(= 0.9.4git20200323-0ubuntu6.2)"];
	"plymouth" -> "init-system-helpers" [color=blue,label="(>= 1.18)"];
	"init-system-helpers" -> "perl-base" [color=blue,label="(>= 5.20.1-3)"];
	"perl-base" -> "libcrypt1" [color=purple,style=bold,label="(>= 1:4.1.0)"];
	"perl-base" -> "dpkg" [color=purple,style=bold,label="(>= 1.17.17)"];
	"plymouth" -> "lsb-base" [color=blue,label="(>= 3.0-6)"];
	"plymouth" -> "systemd" [color=blue,label="(>= 232-8~)"];
	"plymouth" -> "udev" [color=blue,label="(>= 232-8~)"];
	"udev" -> "libacl1" [color=blue,label="(>= 2.2.23)"];
	"udev" -> "libblkid1" [color=blue,label="(>= 2.24)"];
	"udev" -> "libkmod2" [color=blue,label="(>= 5~)"];
	"libkmod2" -> "liblzma5" [color=blue,label="(>= 5.1.1alpha+20120614)"];
	"libkmod2" -> "libssl1.1" [color=blue,label="(>= 1.1.0)"];
	"libssl1.1" -> "alt1":"debconf" [color=blue,label="(>= 0.5)"];
	"udev" -> "libselinux1" [color=blue,label="(>= 2.1.9)"];
	"libselinux1" -> "libpcre2-8-0" [color=blue,label="(>= 10.22)"];
	"udev" -> "adduser" [color=blue];
	"adduser" -> "passwd" [color=blue];
	"adduser" -> "alt1":"debconf" [color=blue,label="(>= 0.5)"];
	"udev" -> "alt2":"dpkg" [color=blue,label="(>= 1.19.3)"];
	"alt2":"systemd-sysv" -> "systemd" [color=purple,style=bold];
	"alt2":"systemd-sysv" -> "systemd" [color=blue,label="(= 245.4-4ubuntu3.5)"];
	"alt2":"systemd-sysv" -> "file-rc" [color=red];
	"alt2":"systemd-sysv" -> "systemd-shim" [color=red];
	"alt2":"systemd-sysv" -> "sysvinit-core" [color=red];
	"alt2":"systemd-sysv" -> "libpam-systemd";
	"libpam-systemd" -> "libpam0g" [color=blue,label="(>= 0.99.7.1)"];
	"libpam0g" -> "libaudit1" [color=blue,label="(>= 1:2.2.1)"];
	"libaudit1" -> "libaudit-common" [color=blue,label="(>= 1:2.8.5-2ubuntu6)"];
	"libaudit1" -> "libcap-ng0" [color=blue,label="(>= 0.7.9)"];
	"libpam0g" -> "alt1":"debconf" [color=blue,label="(>= 0.5)"];
	"libpam-systemd" -> "systemd" [color=blue,label="(= 245.4-4ubuntu3.5)"];
	"libpam-systemd" -> "libpam-runtime" [color=blue,label="(>= 1.0.1-6)"];
	"libpam-runtime" -> "alt1":"debconf" [color=blue,label="(>= 0.5)"];
	"libpam-runtime" -> "alt3":"debconf" [color=blue,label="(>= 1.5.19)"];
	"libpam-runtime" -> "libpam-modules" [color=blue,label="(>= 1.0.1-6)"];
	"libpam-modules" -> "libaudit1" [color=purple,style=bold,label="(>= 1:2.2.1)"];
	"libpam-modules" -> "libcrypt1" [color=purple,style=bold,label="(>= 1:4.1.0)"];
	"libpam-modules" -> "libdb5.3" [color=purple,style=bold];
	"libpam-modules" -> "libpam0g" [color=purple,style=bold,label="(>= 1.3.1)"];
	"libpam-modules" -> "libselinux1" [color=purple,style=bold,label="(>= 2.1.9)"];
	"libpam-modules" -> "alt1":"debconf" [color=purple,style=bold,label="(>= 0.5)"];
	"libpam-modules" -> "libpam-modules-bin" [color=purple,style=bold,label="(= 1.3.1-5ubuntu4.1)"];
	"libpam-modules-bin" -> "libaudit1" [color=blue,label="(>= 1:2.2.1)"];
	"libpam-modules-bin" -> "libcrypt1" [color=blue,label="(>= 1:4.1.0)"];
	"libpam-modules-bin" -> "libpam0g" [color=blue,label="(>= 0.99.7.1)"];
	"libpam-modules-bin" -> "libselinux1" [color=blue,label="(>= 1.32)"];
	"libpam-modules" -> "libpam-mkhomedir" [color=red];
	"libpam-modules" -> "libpam-motd" [color=red];
	"libpam-modules" -> "libpam-umask" [color=red];
	"libpam-modules" -> "update-motd";
	"update-motd" -> "libpam-modules" [color=blue,label="(>= 1.0.1-9ubuntu3)"];
	"libpam-runtime" -> "libpam0g-util" [color=red];
	"libpam-systemd" -> "dbus" [color=blue];
	"libpam-systemd" -> "alt2":"systemd-sysv" [color=blue];
	"alt2":"systemd-sysv" -> "libnss-systemd";
	"libnss-systemd" -> "systemd" [color=blue,label="(= 245.4-4ubuntu3.5)"];
	"udev" -> "libudev1" [color=blue,label="(= 245.4-4ubuntu3.5)"];
	"udev" -> "util-linux" [color=blue,label="(>= 2.27.1)"];
	"util-linux" -> "libaudit1" [color=purple,style=bold,label="(>= 1:2.2.1)"];
	"util-linux" -> "libblkid1" [color=purple,style=bold,label="(>= 2.31.1)"];
	"util-linux" -> "libcap-ng0" [color=purple,style=bold,label="(>= 0.7.9)"];
	"util-linux" -> "libcrypt1" [color=purple,style=bold,label="(>= 1:4.1.0)"];
	"util-linux" -> "libmount1" [color=purple,style=bold,label="(>= 2.34)"];
	"libmount1" -> "libblkid1" [color=blue,label="(>= 2.17.2)"];
	"libmount1" -> "libselinux1" [color=blue,label="(>= 2.6-3~)"];
	"util-linux" -> "libpam0g" [color=purple,style=bold,label="(>= 0.99.7.1)"];
	"util-linux" -> "libselinux1" [color=purple,style=bold,label="(>= 2.6-3~)"];
	"util-linux" -> "libsmartcols1" [color=purple,style=bold,label="(>= 2.34)"];
	"util-linux" -> "libsystemd0" [color=purple,style=bold];
	"libsystemd0" -> "libgcrypt20" [color=purple,style=bold,label="(>= 1.8.0)"];
	"libgcrypt20" -> "libgpg-error0" [color=blue,label="(>= 1.25)"];
	"libgpg-error0" -> "libgpg-error-l10n";
	"libsystemd0" -> "liblz4-1" [color=purple,style=bold,label="(>= 0.0~r122)"];
	"libsystemd0" -> "liblzma5" [color=purple,style=bold,label="(>= 5.1.1alpha+20120614)"];
	"util-linux" -> "libtinfo6" [color=purple,style=bold,label="(>= 6)"];
	"util-linux" -> "libudev1" [color=purple,style=bold,label="(>= 183)"];
	"util-linux" -> "libuuid1" [color=purple,style=bold,label="(>= 2.16)"];
	"libuuid1" -> "uuid-runtime";
	"uuid-runtime" -> "libuuid1" [color=purple,style=bold,label="(>= 2.25-5~)"];
	"uuid-runtime" -> "adduser" [color=blue];
	"uuid-runtime" -> "libsmartcols1" [color=blue,label="(>= 2.27~rc1)"];
	"uuid-runtime" -> "libsystemd0" [color=blue];
	"uuid-runtime" -> "libuuid1" [color=blue,label="(>= 2.31.1)"];
	"util-linux" -> "login" [color=blue,label="(>= 1:4.5-1.1~)"];
	"login" -> "libaudit1" [color=purple,style=bold,label="(>= 1:2.2.1)"];
	"login" -> "libcrypt1" [color=purple,style=bold,label="(>= 1:4.1.0)"];
	"login" -> "libpam0g" [color=purple,style=bold,label="(>= 0.99.7.1)"];
	"login" -> "libpam-runtime" [color=purple,style=bold];
	"login" -> "libpam-modules" [color=purple,style=bold,label="(>= 1.1.8-1)"];
	"udev" -> "hal" [color=red];
	"plymouth" -> "libdrm2" [color=blue,label="(>= 2.4.47)"];
	"libdrm2" -> "libdrm-common" [color=blue,label="(>= 2.4.102-1ubuntu1~20.04.1)"];
	"plymouth" -> "libplymouth5" [color=blue,label="(>= 0.9.4git20200109)"];
	"libplymouth5" -> "libpng16-16" [color=blue,label="(>= 1.6.2-1)"];
	"libplymouth5" -> "libudev1" [color=blue,label="(>= 183)"];
	"plymouth" -> "console-common" [color=red];
	"plymouth" -> "alt4";
	"alt4":"plymouth-theme-ubuntu-text" -> "libplymouth5" [color=blue,label="(>= 0.9.2)"];
	"alt4":"plymouth-theme-ubuntu-text" -> "plymouth" [color=blue,label="(= 0.9.4git20200323-0ubuntu6.2)"];
	"alt4":"plymouth-theme-ubuntu-text" -> "lsb-release" [color=blue];
	"lsb-release" -> "python3:any" [color=blue];
	"python3:any" -> "python3" [dir=back,arrowtail=inv,color=green];
	"python3" -> "python3-minimal" [color=purple,style=bold,label="(= 3.8.2-0ubuntu2)"];
	"python3-minimal" -> "python3.8-minimal" [color=purple,style=bold,label="(>= 3.8.2-1~)"];
	"python3.8-minimal" -> "libpython3.8-minimal" [color=blue,label="(= 3.8.5-1~20.04.2)"];
	"libpython3.8-minimal" -> "libssl1.1" [color=blue,label="(>= 1.1.1)"];
	"libpython3.8-minimal" -> "libpython3.8-stdlib";
	"libpython3.8-stdlib" -> "libpython3.8-minimal" [color=blue,label="(= 3.8.5-1~20.04.2)"];
	"libpython3.8-stdlib" -> "mime-support" [color=blue];
	"mime-support" -> "bzip2";
	"bzip2" -> "libbz2-1.0" [color=blue,label="(= 1.0.8-2)"];
	"mime-support" -> "file";
	"file" -> "libmagic1" [color=blue,label="(= 1:5.38-4)"];
	"libmagic1" -> "libbz2-1.0" [color=blue];
	"libmagic1" -> "liblzma5" [color=blue,label="(>= 5.1.1alpha+20120614)"];
	"libmagic1" -> "libmagic-mgc" [color=blue,label="(= 1:5.38-4)"];
	"mime-support" -> "xz-utils";
	"xz-utils" -> "liblzma5" [color=blue,label="(>= 5.2.2)"];
	"xz-utils" -> "xz-lzma" [color=red];
	"libpython3.8-stdlib" -> "libbz2-1.0" [color=blue];
	"libpython3.8-stdlib" -> "libcrypt1" [color=blue,label="(>= 1:4.1.0)"];
	"libpython3.8-stdlib" -> "libdb5.3" [color=blue];
	"libpython3.8-stdlib" -> "libffi7" [color=blue,label="(>= 3.3~20180313)"];
	"libpython3.8-stdlib" -> "liblzma5" [color=blue,label="(>= 5.1.1alpha+20120614)"];
	"libpython3.8-stdlib" -> "libmpdec2" [color=blue];
	"libpython3.8-stdlib" -> "libncursesw6" [color=blue,label="(>= 6)"];
	"libncursesw6" -> "libtinfo6" [color=blue,label="(= 6.2-0ubuntu2)"];
	"libncursesw6" -> "libgpm2";
	"libpython3.8-stdlib" -> "libreadline8" [color=blue,label="(>= 7.0~beta)"];
	"libreadline8" -> "readline-common" [color=blue];
	"readline-common" -> "alt5":"dpkg" [color=blue,label="(>= 1.15.4)"];
	"alt5":"install-info" -> "dpkg" [color=purple,style=bold,label="(>= 1.16.1)"];
	"readline-common" -> "libreadline-common" [color=red];
	"libreadline8" -> "libtinfo6" [color=blue,label="(>= 6)"];
	"libpython3.8-stdlib" -> "libsqlite3-0" [color=blue,label="(>= 3.7.15)"];
	"libpython3.8-stdlib" -> "libtinfo6" [color=blue,label="(>= 6)"];
	"libpython3.8-stdlib" -> "libuuid1" [color=blue,label="(>= 2.20.1)"];
	"python3.8-minimal" -> "libexpat1" [color=blue,label="(>= 2.1~beta3)"];
	"python3.8-minimal" -> "python3.8";
	"python3-minimal" -> "dpkg" [color=blue,label="(>= 1.13.20)"];
	"python3" -> "python3.8" [color=blue,label="(>= 3.8.2-1~)"];
	"python3" -> "libpython3-stdlib" [color=blue,label="(= 3.8.2-0ubuntu2)"];
	"libpython3-stdlib" -> "libpython3.8-stdlib" [color=blue,label="(>= 3.8.2-1~)"];
	"python3:any" [shape=octagon];
	"lsb-release" -> "distro-info-data" [color=blue];
	"lsb-release" -> "apt";
	"alt4":"plymouth-theme" -> "Pr_plymouth-theme" [label="-20-",dir=back,arrowtail=inv,color=green];
	"Pr_plymouth-theme" [label="...",style=rounded];
	"plymouth-label" -> "libcairo2" [color=blue,label="(>= 1.14.0)"];
	"plymouth-label" -> "libglib2.0-0" [color=blue,label="(>= 2.12.0)"];
	"plymouth-label" -> "libpango-1.0-0" [color=blue,label="(>= 1.14.0)"];
	"plymouth-label" -> "libpangocairo-1.0-0" [color=blue,label="(>= 1.14.0)"];
	"plymouth-label" -> "libplymouth5" [color=blue,label="(>= 0.9.4git20190712)"];
	"plymouth-label" -> "fonts-ubuntu" [color=blue];
	"plymouth-label" -> "fontconfig-config" [color=blue];
	"fontconfig-config" -> "ucf" [color=blue,label="(>= 0.29)"];
	"fontconfig-config" -> "alt6" [color=blue];
	"desktop-base" [style="setlinewidth(2)"]
	"file-rc" [style=filled,fillcolor=oldlace];
	"libharfbuzz0" [style=filled,fillcolor=oldlace];
	"libharfbuzz0a" [style=filled,fillcolor=oldlace];
	"libpam-mkhomedir" -> "libpam-modules" [dir=back,arrowtail=inv,color=green];
	"libpam-mkhomedir" [shape=octagon];
	"libpam-motd" -> "libpam-modules" [dir=back,arrowtail=inv,color=green];
	"libpam-motd" [shape=octagon];
	"libpam-umask" -> "libpam-modules" [dir=back,arrowtail=inv,color=green];
	"libpam-umask" [shape=octagon];
	"libpam0g-util" [style=filled,fillcolor=oldlace];
	"libreadline-common" [style=filled,fillcolor=oldlace];
	"systemd-shim" [style=filled,fillcolor=oldlace];
	"sysvinit-core" [style=filled,fillcolor=oldlace];
	"xz-lzma" [style=filled,fillcolor=oldlace];
	alt1 [
		shape = "record"
		label = "<debconf> \{debconf\} | <debconf-2.0> debconf-2.0"
	]
	alt2 [
		shape = "record"
		label = "<dpkg> [dpkg] | <systemd-sysv> systemd-sysv"
	]
	alt3 [
		shape = "record"
		label = "<debconf> \{debconf\} | <cdebconf> \{cdebconf\}"
	]
	alt4 [
		shape = "record"
		label = "<plymouth-theme-ubuntu-text> plymouth-theme-ubuntu-text | <plymouth-theme> plymouth-theme"
	]
	alt5 [
		shape = "record"
		label = "<dpkg> [dpkg] | <install-info> install-info"
	]
	alt6 [
		shape = "record"
		label = "<fonts-dejavu-core> fonts-dejavu-core | <ttf-bitstream-vera> ttf-bitstream-vera | <fonts-liberation> fonts-liberation | <fonts-freefont> ?fonts-freefont?"
	]
	virt1 [
		shape = "record"
		style = "rounded"
		label = "<debconf> [debconf] | <cdebconf> [cdebconf]"
	]
	"apt" [shape=diamond];
	"dbus" [shape=diamond];
	"dpkg" [shape=diamond];
	"fontconfig" [shape=diamond];
	"libfontconfig1" [shape=diamond];
	"libglib2.0-0" [shape=diamond];
	"passwd" [shape=diamond];
	"python3.8" [shape=diamond];
	"systemd" [shape=diamond];
	"ucf" [shape=diamond];
}
// Excluded dependencies:
// libc6 libstdc++6 libx11-6 zlib1g
// total size of all shown packages: 158822400
// download size of all shown packages: 29908482
