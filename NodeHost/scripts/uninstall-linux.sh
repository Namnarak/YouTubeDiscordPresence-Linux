#!/usr/bin/env bash
set -euo pipefail

HOST_NAME="com.ytdp.discord.presence"
USER_BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
LAUNCHER="$USER_BIN_DIR/ytdp-native-host"

for dir in \
  "$HOME/.config/google-chrome/NativeMessagingHosts" \
  "$HOME/.config/chromium/NativeMessagingHosts" \
  "$HOME/.config/BraveSoftware/Brave-Browser/NativeMessagingHosts" \
  "$HOME/.config/vivaldi/NativeMessagingHosts" \
  "$HOME/.config/opera/NativeMessagingHosts" \
  "$HOME/.mozilla/native-messaging-hosts" \
  "$HOME/.var/app/com.google.Chrome/config/google-chrome/NativeMessagingHosts" \
  "$HOME/.var/app/org.chromium.Chromium/config/chromium/NativeMessagingHosts" \
  "$HOME/.var/app/com.brave.Browser/config/BraveSoftware/Brave-Browser/NativeMessagingHosts" \
  "$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"; do
  rm -f "$dir/$HOST_NAME.json"
done

rm -f "$LAUNCHER"
echo "Removed YouTubeDiscordPresence native host registrations and launcher."
echo "Project files and NodeHost dependencies were left untouched."
