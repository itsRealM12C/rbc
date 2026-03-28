#!/usr/bin/sh
# beanbird.sh

# 1. Download Beanbird package
curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/4.0.zip -o /tmp/4.0.zip

# 2. Extract and Prepare
unzip -o /tmp/4.0.zip -d /tmp/
rm -rf /tmp/cursors
mv /tmp/4.0 /tmp/cursors

# 3. Apply bind mount
mount --bind /tmp/cursors /usr/share/im

# 4. Restart the UI
initctl restart surface-manager
