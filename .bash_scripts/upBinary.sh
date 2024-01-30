upBinary() {
  cd ~/chain*

  # Fetch tags from remote
  git fetch --tags

  # List the last 10 tags
  echo "Recent 10 tags:"
  git tag | tail -n 10

  # Prompt for tag version
  read -p "Enter git version tag: " version

  # Checkout the chosen tag
  git checkout $version

  # Build and install
  make build && make install 

  # Check the version
   $DAEMON_NAME version

  # Clean up environment
  unset version
}

upBinary
