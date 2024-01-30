installDocker() {
    # Update existing list of packages
    sudo apt update

    # Install prerequisite packages
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add the GPG key for the official Docker repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add the Docker repository to APT sources
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package database with Docker packages
    sudo apt update

    # Install Docker
    sudo apt install -y docker-ce

    # Download the current stable release of Docker Compose
    echo "Attempting to download Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    # Check if Docker Compose was downloaded successfully
    if [ -f "/usr/local/bin/docker-compose" ]
    then
        echo "Docker Compose downloaded successfully."
    else
        echo "Docker Compose was not downloaded correctly. Exiting."
        return 1
    fi

    # Apply executable permissions to the Docker Compose binary
    echo "Applying executable permissions to Docker Compose..."
    sudo chmod +x /usr/local/bin/docker-compose

    # Check if permissions were applied successfully
    echo "Permissions for Docker Compose:"
    ls -lah /usr/local/bin/docker-compose
}
