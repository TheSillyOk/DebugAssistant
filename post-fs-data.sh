# Meow's Debug Assistant
#
# A tool to collect extremely verbose debug log from the Android system.
# LICENSE: BSD 3-Clause by ThePedroo

SAVE_FOLDER="/data/local/tmp/DebugAssistant"
mkdir -p "$SAVE_FOLDER"

start_log() {
  local suffix="$1"

  watch_logcat "$suffix"
  watch_dmesg "$suffix"
}

prepare_file() {
  local file_path="$1"

  rm "$file_path"
  touch "$file_path"
  chown shell:shell "$file_path"
}

watch_logcat() {
  local file_path="$SAVE_FOLDER/DebugAssistant$1.log"
  prepare_file "$file_path"

  while [ ! ];do logcat;sleep 1;done > "$file_path" &
}

watch_dmesg() {
  local file_path="$SAVE_FOLDER/DebugAssistant-DMESG$1.log"
  prepare_file "$file_path"

  if dmesg --help 2>&1 | grep -q "\-w"; then
    dmesg -w > "$file_path" &
  else
    while [ ! ];do dmesg > "$file_path";sleep 1;done &
  fi
}

LATEST_SUFFIX=$(basename $(ls -t "$SAVE_FOLDER"/DebugAssistant*.log | grep -v "Redacted" | head -n 1) | grep -oE "([0-9]+)?")
if [[ -z "$(ls $SAVE_FOLDER/DebugAssistant*.log)" || "${LATEST_SUFFIX:-1}" -ge 3 ]]; then
  SUFFIX=""
else
  SUFFIX="-$(( ${LATEST_SUFFIX:-1} + 1 ))"
fi

start_log "$SUFFIX"
