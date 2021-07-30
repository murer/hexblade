
function cmd_backup() {
    mkdir -p /mnt/hexblade/backup
    cd /mnt/hexblade/installer
    rsync -a --delete -x /mnt/hexblade/installer/ /mnt/hexblade/backup/
}

function cmd_backup_restore() {
    rsync -a --delete /mnt/hexblade/backup/ /mnt/hexblade/installer/
}