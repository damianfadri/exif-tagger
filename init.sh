#!/bin/bash

# Determine the directory where the script is located
SCRIPT_DIR="$(pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.json"
SYNC_SCRIPT="$SCRIPT_DIR/sync.sh"
BASHRC="$HOME/.bashrc"

echo "🚀 Starting initialization..."

# 1. & 2. Install exiftool and jq
echo "📦 Installing dependencies (exiftool, jq)..."
pkg update && pkg install -y exiftool jq

# 3. Create config file (initialized as empty JSON array to prevent jq errors in sync.sh)
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[]" > "$CONFIG_FILE"
    echo "✅ Created empty config file: $CONFIG_FILE"
else
    echo "ℹ️  Config file already exists: $CONFIG_FILE"
fi

# 4. Add sync.sh call to .bashrc
if [ -f "$SYNC_SCRIPT" ]; then
    # Ensure sync script is executable
    chmod +x "$SYNC_SCRIPT"

    if grep -Fq "$SYNC_SCRIPT" "$BASHRC"; then
        echo "ℹ️  sync.sh is already added to $BASHRC"
    else
        echo "" >> "$BASHRC"
        echo "# exif-tagger sync script" >> "$BASHRC"
        echo "$SYNC_SCRIPT" >> "$BASHRC"
        echo "✅ Added sync.sh to $BASHRC"
    fi
else
    echo "⚠️  sync.sh not found at $SYNC_SCRIPT. Skipping .bashrc update."
fi

echo "🎉 Initialization complete!"