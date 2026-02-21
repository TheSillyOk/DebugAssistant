# Meow's Debug Assistant's Secure Censor
#
# A tool to redact sensitive information from the extremely verbose debug logs of Meow's Debug Assistant.
# LICENSE: BSD 3-Clause by ThePedroo

SAVE_FOLDER="/data/local/tmp/DebugAssistant"

printf "Selecting the latest debug log file...\n\n"

LATEST_SUFFIX=$(basename $(ls -t "$SAVE_FOLDER/"DebugAssistant* | grep -v "-Redacted" | head -n 1) | grep -oE "(-[0-9]+)?")
LATEST="DebugAssistant$LATEST_SUFFIX.log"
if [[ ! -f "$SAVE_FOLDER/$LATEST" ]]; then
  printf "[!] No debug logs found. Exiting...\n\n"
  sleep 4
  exit 1
fi

NEW_LOG="$SAVE_FOLDER/DebugAssistant-Redacted.log"
DMESG_LOG="$SAVE_FOLDER/DebugAssistant-DMESG$LATEST_SUFFIX.log"

printf "Latest debug log selected: $LATEST\n\n"

printf "Redacting sensitive information...\n\n"

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
chmod 751 "$NEW_LOG"
printf "Redacted logs in $NEW_LOG\n\n"

cp "$NEW_LOG" /sdcard/Download
cp "$DMESG_LOG" /sdcard/Download/DebugAssistant-DMESG.log
printf "Copied redacted log and matching dmesg to /sdcard/Download...\n\n"
sleep 3
