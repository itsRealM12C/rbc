#!/usr/bin/sh
# beanbird.sh

# 1. Download
/usr/bin/curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/4.0.zip -o /tmp/4.0.zip

# 2. Extract
/usr/bin/unzip -o /tmp/4.0.zip -d /tmp/
/bin/rm -rf /tmp/cursors
/bin/mv /tmp/4.0 /tmp/cursors

# 3. Mount
/bin/mount --bind /tmp/cursors /usr/share/im

# 4. Restart UI
/sbin/initctl restart surface-manager
