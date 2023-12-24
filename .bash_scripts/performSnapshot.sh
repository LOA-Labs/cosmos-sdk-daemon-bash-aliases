performSnapshot() {
  # Check if confirmSnapshot is not defined and prompt for it
  if [[ -z "${confirmSnapshot+x}" ]]; then
    read -p "Confirm Snapshot (y/n): " confirmSnapshot
  fi

  # Check if url is not defined and prompt for it
  if [[ -z "${url+x}" ]]; then
    read -p "Enter URL: " url
  fi

  # if snapshot then do it
  if [[ "$confirmSnapshot" == "y" ]]; then
    if ! command -v pv &> /dev/null
    then
        sudo DEBIAN_FRONTEND=noninteractive apt update
        sudo apt-get install -y pv
    fi
    if ! command -v lz4 &> /dev/null
    then
        sudo DEBIAN_FRONTEND=noninteractive apt update
        sudo apt-get install -y lz4 snapd
    fi
    filename=$(basename "$url")
    echo "Adding snapshot: $filename from $url"
    wget -O "$filename" "$url" --inet4-only
    appstop
    $DAEMON_NAME tendermint unsafe-reset-all --home "$DAEMON_HOME" --keep-addr-book
    extension="${filename##*.}"
    echo "Extension: $extension"
    if [[ "$extension" == "lz4" ]]; then
      lz4 -c -d "$filename" | pv | tar -x -C "$DAEMON_HOME"
    elif [[ "$extension" == "gz" ]]; then
      pv "$filename" | tar -xzf - -C "$DAEMON_HOME"
    elif [[ "$extension" == "tar" ]]; then
      pv "$filename" | tar -xf - -C "$DAEMON_HOME"
    else
      echo "Unsupported file extension: $extension"
      return
    fi
    # Check if the last command was successful before running appstart
    if [ $? -eq 0 ]; then
      appstart
    else
      echo "Extraction failed."
    fi
  fi

  unset confirmSnapshot
  unset url
}
