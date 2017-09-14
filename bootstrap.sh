#!/bin/bash

set -e

SRC_DIRECTORY="/Users/kayibal/code/osx-provision"
ANSIBLE_DIRECTORY="$SRC_DIRECTORY/ansible"

# Make the code directory
mkdir -p $SRC_DIRECTORY

# Download and install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Modify the PATH
export PATH=/usr/local/bin:$PATH

# Download and install git
if [[ ! -x /usr/local/bin/git ]]; then
    echo "Info   | Install   | git"
    brew install git
fi

git clone https://github.com/kayibal/provision.git $SRC_DIRECTORY

# Download and install python
if [[ ! -x /usr/local/bin/python ]]; then
    echo "Info   | Install   | python"
    brew install python --framework --with-brewed-openssl
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    brew install ansible
fi

# FIX ANSIBLE PERMISSIONS
chmod -R 750 $SRC_DIRECTORY
chmod -R 660 $ANSIBLE_DIRECTORY/inventories/*

# Provision the box
# ansible-playbook -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local
ansible-playbook --ask-sudo-pass -i $ANSIBLE_DIRECTORY/inventories/osx.ini $ANSIBLE_DIRECTORY/playbook.yml --connection=local
