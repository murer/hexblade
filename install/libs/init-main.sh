
cmd_prepare() {
  sudo apt -y install software-properties-common
  sudo apt-add-repository universe
  sudo apt install -y --no-install-recommends \
    gdisk fdisk gpart \
    cryptsetup \
    debootstrap debconf-utils \
    arch-install-scripts \
    vim curl wget \
    binutils \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    mtools \
    squashfs-tools \
    net-tools \
    nmap \
    ncat \
    git \
    socat \
    crudini \
    htop
}
