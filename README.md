# EXIF Tagger

## Overview

EXIF Tagger automatically restores missing "Date Taken" metadata for images and videos, fixing gallery sorting issues caused by apps that strip EXIF data.

It applies timestamps based on configurable rules:
*   **FileModifyDate**: Uses the file's last modification time.
*   **Filename**: Extracts the date from the filename.

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