
function cmd_backup() {
    mkdir -p /mnt/hexblade/backup
    cd /mnt/hexblade/installer
    rsync -a --delete /mnt/hexblade/installer/ /mnt/hexblade/backup/
}

function cmd_restore() {
    rsync -a --delete /mnt/hexblade/backup/ /mnt/hexblade/installer/
}