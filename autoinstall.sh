#/bin/bash

# Prompt user for config application
echo "Enter your name:"
read NAME
echo "Enter your e-mail:"
read EMAIL
echo "Enter your stash username"
read STASH_USER
echo "Enter your stash password"
read STASH_PWD

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

function print_ok {
    printf "$1%s%*s%s" "$GREEN" $(($(tput cols)-${#1})) "[OK]" "$NORMAL"
}

function print_fail {
    printf "$1%s%*s%s" "$RED" $(($(tput cols)-${#1})) "[FAIL]" "$NORMAL"
}

# Basic package
sudo apt-get update
sudo apt-get install \
    curl \
    sysstat \
    shutter \
    terminator \
    dos2unix \
    vim \
    screen \
    wireshark \
    git gitk git-gui meld \
    python2.7 python-pip \
    lua5.1 luarocks \
    build-essential libssl-dev libxml2-dev libxslt1-dev \
    openssh-client \
    sshpass

# git config
git config --global user.name $NAME
git config --global user.email $EMAIL

# ssh config
APP="ssh"
SSH_DIR="/home/$USER/.ssh/"
if [[ ! -a $SSH_DIR ]] ; then
    mkdir $SSH_DIR -p
    ssh-keygen -q -t rsa -f ${SSH_DIR}id_rsa -N ""
fi
ls ${SSH_DIR}id_rsa.pub > /dev/null 2>&1 && print_ok $APP || print_fail $APP

# Copy key to stash
#authentification
#curl -X POST -d "{\"key\":{\"text\":\"$(cat $SSH_DIR/id_rsa.pub)\"}, \"permission\": \"REPO_WRITE\" }" https://rabbit.can2go.com/stash/rest/keys/1.0/projects/~$STASH_USER/ssh
#

# Install Docker
APP="docker"
curl -fsSL https://get.docker.com/ | sh
sudo useradd -G docker $USER
docker -v > /dev/null 2>&1 && print_ok $APP || print_fail $APP

# Install Wiser project
cd ~
git clone ssh://git@rabbit.can2go.com:2083/bb/wiser-thermostat.git
cd wiser-thermostat
git submodule update --init --recursive
git checkout develop
git submodule foreach git checkout develop

# Install Bumble Bee App framework docker
cd ~
git clone ssh://git@rabbit.can2go.com:2083/bb/linux-build-vm.git
cd linux-build-vm
git checkout feature/docker-rg
./go.sh #start wihtout entering
