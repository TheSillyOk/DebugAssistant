#!/bin/bash

# Meow's Debug Assistant's Secure Censor
#
# A tool to redact sensitive information from the extremely verbose debug logs of Meow's Debug Assistant.
# LICENSE: BSD 3-Clause by ThePedroo

SAVE_FOLDER="/data/local/tmp/DebugAssistant"
mkdir -p "$SAVE_FOLDER"

echo "Selecting the latest debug log file..."
echo ""

LATEST=$(basename $(ls -t "$SAVE_FOLDER"/DebugAssistant* | grep -v "-Redacted" | head -n 1))
if [[ "$LATEST" == "" ]]; then
  echo "No debug log found."
  exit 1
fi

echo "Latest debug log selected: $LATEST"

NEW_LOG="$SAVE_FOLDER/DebugAssistant-Redacted.log"

echo ""
echo "Redacting sensitive information..."

sed -E                                                                   \
  -e 's/([0-9]{1,3}\.){3}[0-9]{1,3}/XXX.XXX.XXX/g'                       \
                                                                         \
  -e 's/Created new content cache dir \[[^]]+\]/Created new content cache dir [REDACTED]/g' \
                                                                         \
  -e 's/[a-zA-Z0-9._%+-]+@([a-z0-9-]*[a-z][a-z0-9-]*\.)+[a-z]{2,}/REDACTED_EMAIL/g' \
                                                                         \
  -e 's/SSID: <[^>]+>/SSID: <REDACTED>/g'                                \
  -e 's/BSSID: [0-9a-fA-F:]+/BSSID: XX:XX:XX:XX:XX:XX/g'                 \
  -e 's/MAC: [0-9a-fA-F:]+/MAC: XX:XX:XX:XX:XX:XX/g'                     \
                                                                         \
  -e 's/LinkAddresses: \[[^]]+\]/LinkAddresses: [REDACTED]/g'            \
  -e 's/Routes: \[[^]]+\]/Routes: [REDACTED]/g'                          \
  -e 's/ServerAddress: [^ ]+/ServerAddress: REDACTED/g'                  \
  -e 's/InterfaceName: [^ ]+/InterfaceName: REDACTED/g'                  \
  -e 's/SSID: "[^"]+"/SSID: "REDACTED"/g'                                \
  -e 's/SSID="[^"]+"/SSID="REDACTED"/g'                                  \
  -e 's/BSSID=[0-9a-fA-F:]+/BSSID=XX:XX:XX:XX:XX:XX/g'                   \
  -e 's/MAC=[0-9a-fA-F:]+/MAC=XX:XX:XX:XX:XX:XX/g'                       \
  -e 's/(Requesting package name: <[^>]*>)"[^"]*"/\1"REDACTED"/g'        \
                                                                         \
  -e 's/Cannot find network with networkId -1 or configKey "[^"]*"/Cannot find network with networkId -1 or configKey "REDACTED"/g' \
                                                                         \
  -e 's/connectToNetwork "[^"]*"/connectToNetwork "REDACTED"/g'          \
                                                                         \
  -e 's/Selecting supplicant SSID "[^"]*"/Selecting supplicant SSID "REDACTED"/g' \
                                                                         \
  -e 's/Trying to associate with SSID '\''[^'\'']*'\''/Trying to associate with SSID '\''REDACTED'\''/g' \
                                                                         \
  -e 's/addressUpdated: [^ ]+ on ifindex [0-9]+ flags 0x[0-9a-fA-F]+ scope [0-9]+/addressUpdated: REDACTED on ifindex REDACTED flags REDACTED scope REDACTED/g' \
                                                                         \
                                                                         \
                                                                         \
  "$SAVE_FOLDER/$LATEST" > "$NEW_LOG"

echo ""
echo "Redacted logs in $NEW_LOG"
echo ""

cp "$NEW_LOG" /sdcard/Download
echo "Copied redacted log to /sdcard/Download..."
