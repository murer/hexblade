
function system_backup_prepare() {
  hexblade_crypt_dev=/dev/nvme0n1p2
  
  mkdir -p /mnt/hexblade/sysbak 
  mkdir -p /semilivedata/ubuntu/bak/latest

  ls /dev/mapper/LOCALCRYPTED || cryptsetup open "$hexblade_crypt_dev" LOCALCRYPTED

  if ! findmnt | grep /mnt/hexblade/sysbak; then
    mount /dev/mapper/LOCAL-ROOT /mnt/hexblade/sysbak
  fi
}

function cmd_system_backup_done() {
  umount /mnt/hexblade/sysbak
  cryptsetup close LOCALCRYPTED
}

function cmd_system_backup_create() {
  system_backup_prepare
  rsync -a --delete -x --info=progress2 /mnt/hexblade/sysbak/ /semilivedata/ubuntu/bak/latest/
}

function cmd_system_backup_restore() {
  system_backup_prepare
  rsync -a --delete -x --info=progress2 /semilivedata/ubuntu/bak/latest/ /mnt/hexblade/sysbak/ 
}

function cmd_system_tag_create() {
  hexblade_crypt_tag="${1?'tag like v1.2.3'}"
  cd /semilivedata/ubuntu/bak
  find latest | wc
  du -hs latest
  hexblade_total_size="$(du -bs latest | cut -f1)"
  tar cpf - latest | pv -s "$hexblade_total_size" | gzip -9 > "$hexblade_crypt_tag.tar.gz"
  #tar czpf "$hexblade_crypt_tag.tar.gz" latest
  cd -
}

function cmd_system_tag_restore() {
  hexblade_crypt_tag="${1?'tag like v1.2.3'}"
  cd /semilivedata/ubuntu/bak
  [[ -f "$hexblade_crypt_tag.tar.gz" ]]
  rm -rf latest
  pv "$hexblade_crypt_tag.tar.gz" | tar xzpf -
  cd -
}

