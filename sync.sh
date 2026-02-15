
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/exif_sync.log"
CONFIG_FILE="$SCRIPT_DIR/config.json"

log_msg() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

process_directory() {
    local dir="$1"
    local source="$2"
    if ! exiftool -m -q -r -if 'not $DateTimeOriginal' \
                -P -overwrite_original \
                "-DateTimeOriginal<$source" \
                "$dir" 2>/dev/null; then
        log_msg "⚠️ Issues processing ($source): $dir"
    fi
}

log_msg "🚀 Starting sync..."

if [ ! -f "$CONFIG_FILE" ]; then
    log_msg "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    log_msg "❌ jq is required but not installed."
    exit 1
fi

jq -c '.[]' "$CONFIG_FILE" | while read -r item; do
    DIR=$(echo "$item" | jq -r '.directory')
    MODE=$(echo "$item" | jq -r '.mode')

    if [ -d "$DIR" ]; then
        log_msg "Processing directory: $DIR using $MODE"
        process_directory "$DIR" "$MODE"
    else
        log_msg "⚠️ Directory not found: $DIR"
    fi
done

log_msg "✅ Sync finished."