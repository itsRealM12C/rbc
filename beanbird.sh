#!/usr/bin/sh

# Download the file to /tmp/
curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/4.0.zip -o /tmp/4.0.zip

# Unzip and prepare directories
unzip -o /tmp/4.0.zip -d /tmp/
rm -rf /tmp/cursors
mv /tmp/4.0 /tmp/cursors

# Apply the bind mount and restart surface manager
mount --bind /tmp/cursors /usr/share/im
initctl restart surface-manager
