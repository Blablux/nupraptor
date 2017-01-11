#!/bin/bash
# ==============================================
# Clones a Raspberry Pi SD Card to a remote
# storage
#
# This script must be run as root. It should be
# put in the root crontab with `sudo crontab -e`
# Table of contents
# 1. Setting variables
# 2. Functions
# 3. Main code
#   3.1. Testing remote storage
#   3.2. Cloning
#   3.3. Post-process
# ==============================================

# ==============================================
# 1. Setting variables (change to your taste)
# ==============================================
LOCAL_STORAGE="/dev/mmcblk0"
REMOTE_STORAGE="/path/to/remote/storage/"
TIMESTAMP="$(date +"%Y%m%d")"
HOST="$(hostname)"
CONTACT="root@example.com"

# ==============================================
# 2. Functions
# ==============================================

# ==============================================
# 3. Main code
# 3.1. Testing remote storage
# ==============================================
if [ ! -d "$REMOTE_STORAGE" ]; then
    exit $REMOTE_STORAGE " can't be read!"
fi

# ==============================================
# 3.2. Cloning
# ==============================================
dd bs=4M if=$LOCAL_STORAGE | gzip > $REMOTE_STORAGE/$HOST/$HOST.$TIMESTAMP.img.gz 2> /tmp/output.txt
  # DEBUG: echo dd bs=4M if="$LOCAL_STORAGE" | gzip > "$REMOTE_STORAGE"/"$HOST"."$TIMESTAMP".img.gz 2> /tmp/output.txt

# ==============================================
# 3.3. Post-process
# ==============================================
# TODO: Finished scripts
cat /tmp/output.txt mail -s "$HOSTNAME backup report" $CONTACT
