function upGo() {
    local version=$1
    cd ~
    wget https://go.dev/dl/go${version}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${version}.linux-amd64.tar.gz
    rm go${version}.linux-amd64.tar.gz
    echo "$(go version)"
}
