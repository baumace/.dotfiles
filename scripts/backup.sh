#!/bin/bash

# === CONFIG ===
BACKUP_MOUNT="/home/jawb/usb/BACKUP"
LOG_FILE="$HOME/.local/share/backup/backup.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
DEST="$BACKUP_MOUNT/snapshots/$TIMESTAMP"
LATEST_LINK="$BACKUP_MOUNT/latest"
MAX_SNAPSHOTS=5  # How many snapshots to keep

SOURCES=(
    "$HOME/documents"
    "$HOME/media/pictures"
    "$HOME/media/videos"
    "$HOME/.ssh"
)

# === SETUP ===
mkdir -p "$(dirname "$LOG_FILE")"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=============================="
echo "Backup started: $TIMESTAMP"
echo "=============================="

# === CHECK USB IS MOUNTED ===
if ! mountpoint -q "$BACKUP_MOUNT"; then
    echo "ERROR: Backup drive not mounted at $BACKUP_MOUNT. Aborting."
    exit 1
fi

# === RUN RSYNC ===
RSYNC_OPTS="-aAXhv --delete --progress"

if [ -L "$LATEST_LINK" ] && [ -d "$LATEST_LINK" ]; then
    RSYNC_OPTS="$RSYNC_OPTS --link-dest=$LATEST_LINK"
fi

rsync $RSYNC_OPTS "${SOURCES[@]}" "$DEST/"

if [ $? -ne 0 ]; then
    echo "ERROR: rsync failed."
    exit 1
fi

# === UPDATE LATEST SYMLINK ===
ln -snf "$DEST" "$LATEST_LINK"
echo "Snapshot saved to: $DEST"

# === PRUNE OLD SNAPSHOTS ===
echo "Pruning old snapshots (keeping $MAX_SNAPSHOTS)..."
ls -1dt "$BACKUP_MOUNT/snapshots"/*/ 2>/dev/null | tail -n +$((MAX_SNAPSHOTS + 1)) | xargs -r rm -rf
echo "Pruning complete."

echo "Backup finished: $(date +"%Y-%m-%d_%H-%M")"
