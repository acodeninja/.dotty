#!/usr/bin/env bash

# Get the current directory
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing .dotty"

echo "Installing binary packages"

read -p "Would you like to install packer? [y/N]" -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Downloading packer"
    curl -sL -o packer_1.1.3_linux_amd64.zip "https://releases.hashicorp.com/packer/1.1.3/packer_1.1.3_linux_amd64.zip"

    echo "Unzipping packer"
    unzip packer_1.1.3_linux_amd64.zip

    echo "Installing packer"
    mv packer ./bin/packer
    rm packer_1.1.3_linux_amd64.zip
fi

echo "Installing bash source file"
echo "source $THIS_DIR/SOURCEME.sh" >> ~/.bashrc
