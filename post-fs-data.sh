# Meow's Debug Assistant
#
# A tool to collect extremely verbose debug log from the Android system.
# LICENSE: BSD 3-Clause by ThePedroo

SAVE_FOLDER=/data/local/tmp/DebugAssistant

mkdir -p "$SAVE_FOLDER"

function prepare_file() {
  local file_path="$SAVE_FOLDER/DebugAssistant$1.log"

  rm "$file_path" || true
  touch "$file_path"
  chown shell:shell "$file_path"
}

function watch_logcat() {
  local file_path="$SAVE_FOLDER/DebugAssistant$1.log"

  while [ ! ];do logcat;sleep 1;done > "$file_path" &
}

LATEST=$(ls -t $SAVE_FOLDER | head -1)
if [[ "$LATEST" != "" ]]; then
  index=1
  for f in "$SAVE_FOLDER"/; do
    LATEST=$(ls -t "$SAVE_FOLDER" | awk NR==$index)
    if [[ "$LATEST" == "" ]]; then
      prepare_file ""
      watch_logcat ""
      break
    fi
    if [[ "$LATEST" == "DebugAssistant.log" ]]; then
      prepare_file "-2"
      watch_logcat "-2"
      break
    fi
    if [[ "$LATEST" == "DebugAssistant-2.log" ]]; then
      prepare_file "-3"
      watch_logcat "-3"
      break
    fi
    if [[ "$LATEST" == "DebugAssistant-3.log" ]]; then
      prepare_file ""
      watch_logcat ""
      break
    fi
    index=$((index + 1))
  done
else
  prepare_file ""
  watch_logcat ""
fi
