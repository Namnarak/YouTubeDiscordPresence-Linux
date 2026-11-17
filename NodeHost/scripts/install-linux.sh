#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
NODEHOST_DIR="$REPO_ROOT/NodeHost"
USER_BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
LAUNCHER="$USER_BIN_DIR/ytdp-native-host"
HOST_NAME="com.ytdp.discord.presence"
CHROME_EXTENSION_ID="${YTDP_CHROME_EXTENSION_ID:-hnmeidgkfcbpjjjpmjmpehjdljlaeaaa}"
FIREFOX_EXTENSION_ID="${YTDP_FIREFOX_EXTENSION_ID:-@youtubediscordpresence}"

command -v node >/dev/null 2>&1 || {
  echo "Node.js is required. Install Node.js 18 or newer, then rerun this script." >&2
  exit 1
}
command -v npm >/dev/null 2>&1 || {
  echo "npm is required but was not found." >&2
  exit 1
}
command -v python3 >/dev/null 2>&1 || {
  echo "python3 is required to generate native messaging manifests." >&2
  exit 1
}

NODE_BIN="$(command -v node)"
NODE_MAJOR="$(node -p 'Number(process.versions.node.split(".")[0])')"
if (( NODE_MAJOR < 18 )); then
  echo "Node.js 18 or newer is required (found $(node --version))." >&2
  exit 1
fi

echo "Installing NodeHost dependencies..."
npm ci --prefix "$NODEHOST_DIR"
npm --prefix "$NODEHOST_DIR" run precompile

mkdir -p "$USER_BIN_DIR"
cat > "$LAUNCHER" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec "$NODE_BIN" "$NODEHOST_DIR/src/app.js"
EOF
chmod 755 "$LAUNCHER"

write_manifest() {
  local manifest_dir="$1"
  local browser="$2"
  mkdir -p "$manifest_dir"
  MANIFEST_DIR="$manifest_dir" BROWSER_KIND="$browser" HOST_PATH="$LAUNCHER" HOST_NAME="$HOST_NAME" CHROME_EXTENSION_ID="$CHROME_EXTENSION_ID" FIREFOX_EXTENSION_ID="$FIREFOX_EXTENSION_ID" python3 - <<'PY'
import json
import os
from pathlib import Path

manifest = {
    "name": os.environ["HOST_NAME"],
    "description": "YouTubeDiscordPresence native messaging host (Linux)",
    "path": os.environ["HOST_PATH"],
    "type": "stdio",
}
if os.environ["BROWSER_KIND"] == "firefox":
    manifest["allowed_extensions"] = [os.environ["FIREFOX_EXTENSION_ID"]]
else:
    manifest["allowed_origins"] = [
        f"chrome-extension://{os.environ['CHROME_EXTENSION_ID']}/"
    ]

target = Path(os.environ["MANIFEST_DIR"]) / f"{os.environ['HOST_NAME']}.json"
target.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
target.chmod(0o644)
print(f"Registered: {target}")
PY
}

# Chromium-family browsers. Registering a manifest for an absent browser is harmless.
for dir in \
  "$HOME/.config/google-chrome/NativeMessagingHosts" \
  "$HOME/.config/chromium/NativeMessagingHosts" \
  "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts" \
  "$HOME/.config/vivaldi/NativeMessagingHosts" \
  "$HOME/.config/opera/NativeMessagingHosts" \
  "$HOME/.var/app/com.google.Chrome/config/google-chrome/NativeMessagingHosts" \
  "$HOME/.var/app/org.chromium.Chromium/config/chromium/NativeMessagingHosts" \
  "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts"; do
  write_manifest "$dir" chromium
done

# Firefox native messaging manifests (native and Flatpak profiles).
for dir in \
  "$HOME/.mozilla/native-messaging-hosts" \
  "$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"; do
  write_manifest "$dir" firefox
done

echo
echo "YouTubeDiscordPresence Linux native host installed."
echo "Launcher: $LAUNCHER"
echo "Restart your browser and Discord, then play a YouTube video."
echo "For an unpacked Chromium extension, set YTDP_CHROME_EXTENSION_ID to its extension ID before running this installer."
