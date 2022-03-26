#!/usr/bin/env bash

set -e

echo
echo -e '\033[1;30;42m correct execution permissions and move files to destination \033[0m'
chmod a+x /boot.sh \
          /complexChown.sh \
          /entrypoint.sh

mv /complexChown.sh /usr/local/bin/compexChown
mv /entrypoint.sh   /usr/local/bin/entrypoint


echo
echo -e '\033[1;30;42m fetch apt cache and install helpers \033[0m'
apt-get update -q --fix-missing
apt-get -yq install -y --no-install-recommends \
        software-properties-common procps apt-utils apt-transport-https


echo
echo -e '\033[1;30;42m upgrade all installed \033[0m'
apt-get -yq upgrade


echo
echo -e '\033[1;30;42m remove unneeded packages \033[0m'
apt-get -yq autoremove


echo -e '\033[1;30;42m install basic tools \033[0m'
apt-get install -yq \
        python3-setuptools python3-pip python3-pkg-resources \
        python3-jinja2 python3-yaml \
        vim nano jq \
        htop tree tmux screen sudo git zsh ssh screen \
        supervisor expect \
        gnupg openssl \
        curl wget \
        unzip \
        locales locales-all \
        cron \
        libfreetype6-dev \
        dialog

pip install j2cli


echo
echo -e '\033[1;30;42m installing Eclipse Adoptium JDK \033[0m'

# remove existing installations
apt-get remove --auto-remove -qy \
        openjdk*

# add GPG Key for Eclipse Adoptium
keyringPath="/usr/share/keyrings/adoptium.asc"
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee ${keyringPath}
echo "deb [signed-by=${keyringPath}] https://packages.adoptium.net/artifactory/deb $( awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release ) main" | tee /etc/apt/sources.list.d/adoptium.list

# update and install
apt-get -yq update
apt-get -yq install "${JDK_NAME}"


echo
echo -e '\033[1;30;42m defining aliases \033[0m'

set +e

# add aliases
read -d '' bash_alias << 'EOF'
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
EOF

set -e

echo "$bash_alias" >> /etc/bash.bashrc


echo
echo -e '\033[1;30;42m cleaning up installation cache \033[0m'

# perform installation cleanup
apt-get -y clean
apt-get -y autoclean
apt-get -y autoremove
rm -r /var/lib/apt/lists/*
