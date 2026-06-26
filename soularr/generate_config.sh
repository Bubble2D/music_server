#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
CONFIG_DIR="$SCRIPT_DIR/data"
CONFIG_FILE="$CONFIG_DIR/config.ini"

# .env laden
if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: .env nicht gefunden unter $ENV_FILE"
  exit 1
fi
source "$ENV_FILE"

# Pflichtfelder prüfen
for var in lidarr_api slskd_api; do
  if [[ -z "${!var:-}" ]]; then
    echo "ERROR: '$var' ist nicht gesetzt oder leer in der .env"
    exit 1
  fi
done

mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_FILE" << EOCONFIG
[Lidarr]
api_key = $lidarr_api
host_url = http://lidarr:8686
download_dir = /downloads
disable_sync = False

[Slskd]
api_key = $slskd_api
host_url = http://slskd:5030
url_base = /
download_dir = /downloads
delete_searches = False
stalled_timeout = 3600

[Release Settings]
use_most_common_tracknum = True
allow_multi_disc = True
accepted_countries = Europe,Japan,United Kingdom,United States,[Worldwide],Australia,Canada
skip_region_check = False
accepted_formats = CD,Digital Media,Vinyl

[Search Settings]
search_timeout = 5000
maximum_peer_queue = 50
minimum_peer_upload_speed = 0
minimum_filename_match_ratio = 0.8
allowed_filetypes = flac,mp3 320,mp3
ignored_users =
search_for_tracks = True
album_prepend_artist = False
track_prepend_artist = True
EOCONFIG

echo "config.ini erfolgreich generiert: $CONFIG_FILE"
