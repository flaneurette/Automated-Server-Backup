#!/bin/bash

# -------- CONFIG --------
BACKUP_FILE="/secret/path/backup.tar.gz"
ENCRYPTED_FILE="/secret/path/backup.tar.gz.gpg"
LOG_FILE="/secret/path/backup.log"
RECIPIENT="Your Name <email@example.com>"   # GPG recipient, must match GPG key!
ALERT_EMAIL="backups@example.com"          # Where alerts will be sent

# -------- FUNCTION TO SEND ALERT --------
send_alert() {
    SUBJECT="$1"
    BODY="$2"
    echo -e "$BODY" | mail -s "$SUBJECT" "$ALERT_EMAIL"
}

# -------- START LOG --------
echo "----------------------------------------" >> "$LOG_FILE"
echo "Backup started at $(date)" >> "$LOG_FILE"

# -------- EXCLUDES --------
EXCLUDES=(
  /proc
  /sys
  /dev
  /run
  /tmp
  /mnt
  /media
  /lost+found
  "$BACKUP_FILE"
  "$ENCRYPTED_FILE"
)

TAR_EXCLUDES=()
for i in "${EXCLUDES[@]}"; do
    TAR_EXCLUDES+=(--exclude="$i")
done

# -------- CREATE BACKUP --------
echo "Creating backup..." >> "$LOG_FILE"
if sudo tar -cvpzf "$BACKUP_FILE" "${TAR_EXCLUDES[@]}" / >> "$LOG_FILE" 2>&1; then
    echo "Backup created successfully at $(date)" >> "$LOG_FILE"
else
    ERROR_MSG="Backup creation failed at $(date). Check $LOG_FILE for details."
    echo "$ERROR_MSG" >> "$LOG_FILE"
    send_alert "Backup Failed" "$ERROR_MSG"
    exit 1
fi

# -------- ENCRYPT BACKUP --------
echo "Encrypting backup..." >> "$LOG_FILE"
if gpg --batch --yes --trust-model always --encrypt --recipient "$RECIPIENT" -o "$ENCRYPTED_FILE" "$BACKUP_FILE" >> "$LOG_FILE" 2>&1; then
    echo "Backup encrypted successfully at $(date)" >> "$LOG_FILE"
    rm -f "$BACKUP_FILE"
else
    ERROR_MSG="Backup encryption failed at $(date). Check $LOG_FILE for details."
    echo "$ERROR_MSG" >> "$LOG_FILE"
    send_alert "Backup Encryption Failed" "$ERROR_MSG"
    exit 1
fi

echo "Backup process completed at $(date)" >> "$LOG_FILE"
