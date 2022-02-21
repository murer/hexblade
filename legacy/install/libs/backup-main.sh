
function cmd_backup() {
    mkdir -p /mnt/hexblade/backup
    cd /mnt/hexblade/installer
    rsync -a --delete -x /mnt/hexblade/installer/ /mnt/hexblade/backup/
}

function cmd_backup_restore() {
    rsync -a --delete /mnt/hexblade/backup/ /mnt/hexblade/installer/
}

function cmd_backup_export() {
    hexbalde_backup_name="${1?'backup file is required}'}"
    tar cpzf "$hexbalde_backup_name" --one-file-system /mnt/hexblade/backup
}

function cmd_backup_import() {
    rm -rf /mnt/hexblade/backup
    mkdir -p /mnt/hexblade/backup
    hexbalde_backup_name="${1?'backup file is required}'}"
    tar -xpzf "$hexbalde_backup_name" -C /mnt/hexblade/backup --strip-components=3 --numeric-owner
}

