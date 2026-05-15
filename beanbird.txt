#!/bin/sh
# beanbird.sh — Return Beanbird Cursor
# Each step echoes its result so hbchannel exec output shows exactly where it stops.

echo "=== beanbird.sh started ==="

# 1. Download cursor zip
echo "Step 1: Downloading 4.0.zip..."
curl -L https://github.com/itsRealM12C/convert/raw/refs/heads/main/4.0.zip -o /tmp/4.0.zip
echo "curl exit code: $?"
if [ ! -f /tmp/4.0.zip ]; then
    echo "ERROR: /tmp/4.0.zip not found after curl."
    exit 1
fi
echo "Step 1 OK: $(ls -lh /tmp/4.0.zip)"

# 2. Extract
echo "Step 2: Extracting..."
unzip -o /tmp/4.0.zip -d /tmp/
echo "unzip exit code: $?"

# Show what actually extracted so we know the real folder name
echo "Contents of /tmp after extract:"
ls /tmp/

# 3. Find and move the extracted folder
# The zip may extract as 4.0/ or something else — find it dynamically
EXTRACTED=$(find /tmp -maxdepth 1 -type d -name "4*" | head -1)
echo "Found extracted dir: $EXTRACTED"

rm -rf /tmp/cursors
if [ -n "$EXTRACTED" ]; then
    mv "$EXTRACTED" /tmp/cursors
    echo "Step 2 OK: moved $EXTRACTED -> /tmp/cursors"
else
    echo "ERROR: Could not find extracted cursor folder in /tmp"
    exit 1
fi

# 4. Find the real cursor theme path on this TV
echo "Step 3: Finding cursor path..."
for CANDIDATE in /usr/share/icons /usr/share/im /usr/share/cursor /usr/share/X11/cursors; do
    if [ -d "$CANDIDATE" ]; then
        echo "Found candidate: $CANDIDATE"
        MOUNT_TARGET="$CANDIDATE"
        break
    fi
done

if [ -z "$MOUNT_TARGET" ]; then
    echo "WARNING: No standard cursor dir found. Trying /usr/share/icons anyway."
    mkdir -p /usr/share/icons
    MOUNT_TARGET="/usr/share/icons"
fi
echo "Mount target: $MOUNT_TARGET"

# 5. Bind mount
echo "Step 4: Mounting /tmp/cursors -> $MOUNT_TARGET ..."
mount --bind /tmp/cursors "$MOUNT_TARGET"
echo "mount exit code: $?"
if [ $? -ne 0 ]; then
    echo "ERROR: bind mount failed."
    exit 1
fi
echo "Step 4 OK: mount applied."

sync

# 6. Restart compositor
echo "Step 5: Restarting surface-manager..."
initctl restart surface-manager
echo "initctl exit code: $?"
if [ $? -ne 0 ]; then
    echo "initctl failed, trying luna-send fallback..."
    luna-send -n 1 luna://com.webos.service.applicationManager/closeAllApps '{}'
    echo "luna-send exit code: $?"
fi

echo "=== Done. Screen should go black for 10-20 seconds. ==="
