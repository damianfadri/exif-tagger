
LOG_FILE="$HOME/exif_sync.log"
CONFIG_FILE="$(dirname "$0")/config.json"

log_msg() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

process_using_filemodifydate() {
    local dir="$1"
    if ! exiftool -m -q -r -if 'not $DateTimeOriginal' \
                -P -overwrite_original \
                '-DateTimeOriginal<FileModifyDate' \
                "$dir" 2>/dev/null; then
        log_msg "⚠️ Issues processing (FileModifyDate): $dir"
    fi
}

process_using_filename() {
    local dir="$1"
    if ! exiftool -m -q -r -if 'not $DateTimeOriginal' \
                -P -overwrite_original \
                '-DateTimeOriginal<Filename' \
                "$dir" 2>/dev/null; then
        log_msg "⚠️ Issues processing (Filename): $dir"
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
        if [ "$MODE" = "Filename" ]; then
            process_using_filename "$DIR"
        elif [ "$MODE" = "FileModifyDate" ]; then
            process_using_filemodifydate "$DIR"
        fi
    else
        log_msg "⚠️ Directory not found: $DIR"
    fi
done

log_msg "✅ Sync finished."