#!/bin/bash

# -------- CONFIG --------
BACKUP_FILE="/secret/path/backup.tar.gz"
ENCRYPTED_FILE="/secret/path/backup.tar.gz.gpg"
LOG_FILE="/secret/path/backup.log"
RECIPIENT="Your Name <email@emaildomain.com>"   # Must match your public key

# -------- CREATE BACKUP --------
echo "Starting backup at $(date)" >> "$LOG_FILE"

 sudo tar -cvpzf "$BACKUP_FILE" \
  --exclude=/proc \
  --exclude=/sys \
  --exclude=/dev \
  --exclude=/run \
  --exclude=/tmp \
  --exclude=/mnt \
  --exclude=/media \
  --exclude=/lost+found \
  --exclude="$BACKUP_FILE" \
  /

if [ $? -ne 0 ]; then
    echo "Backup creation failed at $(date)" >> "$LOG_FILE"
    exit 1
fi

# -------- ENCRYPT BACKUP --------
gpg --batch --yes --trust-model always --encrypt --recipient "$RECIPIENT" -o "$ENCRYPTED_FILE" "$BACKUP_FILE"

if [ $? -ne 0 ]; then
    echo "Encryption failed at $(date)" >> "$LOG_FILE"
    exit 1
fi

# Remove plain backup
rm -f "$BACKUP_FILE"

echo "Encrypted backup completed at $(date)" >> "$LOG_FILE"
