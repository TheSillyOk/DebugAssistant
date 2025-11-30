# Meow's Debug Assistant
#
# A tool to collect extremely verbose debug log from the Android system.
# LICENSE: BSD 3-Clause by ThePedroo

SAVE_FOLDER=/data/local/tmp/DebugAssistant

mkdir -p "$SAVE_FOLDER"

function prepare_file() {
  local file_path="$1"

  rm "$file_path"
  touch "$file_path"
  chown shell:shell "$file_path"
}

function watch_logcat() {
  local file_path="$SAVE_FOLDER/DebugAssistant$1.log"
  prepare_file "$file_path"

  while [ ! ];do logcat;sleep 1;done > "$file_path" &
}


LATEST=$(basename $(ls -t "$SAVE_FOLDER"/DebugAssistant*.log | grep -v "Redacted" | head -n 1))
if [[ "$LATEST" == "DebugAssistant.log" ]]; then
  SUFFIX="-2"
elif [[ "$LATEST" == "DebugAssistant-2.log" ]]; then
  SUFFIX="-3"
else
  SUFFIX=""
fi

watch_logcat "$SUFFIX"
