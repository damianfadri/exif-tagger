# EXIF Tagger

## Overview

EXIF Tagger is a lightweight utility designed to automatically restore missing "Date Taken" (`DateTimeOriginal`) metadata for images and videos.

Many social media apps (like Facebook Messenger, WhatsApp, Twitter/X) or backup solutions strip EXIF metadata or save files without proper timestamps. This causes gallery apps to display photos in the wrong order, often grouping them by the date they were downloaded rather than when they were actually taken.

This tool scans specified directories and applies the correct timestamp based on configurable rules:
*   **FileModifyDate**: Uses the file's last modification time. This is useful for files downloaded from services that preserve the filesystem timestamp but strip internal metadata.
*   **Filename**: Extracts the date directly from the filename. This is useful for files named with a pattern (e.g., `IMG_20230101_120000.jpg`) but lacking internal tags.

## Prerequisites
1.  Install Termux on your device.
2.  Open Termux and grant storage permissions so the script can access your photos:
    ```bash
    termux-setup-storage
    ```

## How to use

### Installation
1.  Clone this repository or copy the script files to a folder inside Termux.
2.  Navigate to the folder and run the initialization script:
    ```bash
    bash init.sh
    ```

    This script will:
    *   Install the required dependencies (`exiftool` and `jq`).
    *   Create a default `config.json` file if one does not exist.
    *   Add the sync script to your `.bashrc` so it runs automatically when you open Termux.

### Configuration
Edit the `config.json` file to specify which directories to process and which method to use for each.

**Example `config.json`:**
```json
[
  {
    "directory": "/storage/emulated/0/Pictures/Messenger",
    "mode": "FileModifyDate"
  },
  {
    "directory": "/storage/emulated/0/DCIM/Restored",
    "mode": "Filename"
  }
]
```