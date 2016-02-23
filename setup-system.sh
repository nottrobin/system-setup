set -e

# Update apt only if the list is more than an hour old
function update_apt() {
    now=$(date +%s)
    an_hour_ago=$(expr ${now} - 3600)
    apt_last_updated=$(stat -c '%Y' /var/lib/apt/lists)

    if [ ${an_hour_ago} -gt ${apt_last_updated} ]; then
        echo "~ Updating apt"
        sudo apt update
    fi
}

# Add a new apt config setting
# to make it always install package dependencies
# without prompting "are you sure?"
function apt_always_yes() {
    if [ -d /etc/apt/apt.conf.d ] && [ ! -e /etc/apt/apt.conf.d/97always-yes ]; then
        echo "~ Creating /etc/apt/apt.conf.d/97always-yes"
        echo 'APT::Get::Assume-Yes "true";' | sudo tee /etc/apt/apt.conf.d/97always-yes
        echo 'APT::Get::force-yes "true";' | sudo tee -a /etc/apt/apt.conf.d/97always-yes
    fi
}

# Download and install Google Chrome, as best we know how
function install_chrome() {
    echo "~ Installing Google Chrome's dependencies"

    update_apt  # Update apt first
    sudo apt install libxss1 libappindicator1 libindicator7
    echo "~ Downloading google chrome .deb package"
    sudo wget -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    echo "~ Installing downloaded package"
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
}

# Download and install sublime as best we know how
function install_sublime_3() {
    echo "~ Downloading sublime 3 deb package"
    sudo wget -P /tmp http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3065_amd64.deb
    echo "~ Installing downloaded package"
    sudo dpkg -i /tmp/sublime-text_build-3065_amd64.deb
}

# Download and install atom as best we know how
function install_atom() {
    echo "~ Downloading atom deb package"
    wget -O /tmp/atom.deb https://atom.io/download/deb
    echo "~ Installing downloaded package"
    sudo dpkg -i /tmp/atom.deb
}

# Install apt packages in the list
# Prompting each time
function install_apt_packages() {
    possible_packages="git python-pip vim byobu ack-grep bzr curl"
    packages_to_install=""

    echo "~ Choose which packages to install:"
    for package in ${possible_packages}; do
        while true; do
            read -p "Install "${package}"? [Y/n] " install
            case $install in
                [Nn]* ) break;;
                * ) packages_to_install=${packages_to_install}" "${package}; break;;
            esac
        done
    done

    if [ -n "${packages_to_install}" ]; then
        echo "~ Installing chosen packages: "${packages_to_install}
        update_apt  # update apt first
        sudo apt install ${packages_to_install}
    fi
}

# Hub is a great way to manage git with github
function install_github_hub() {
    while true; do
        read -p "Install rake (required)? [Y/n] " install
        case $install in
            [Nn]* ) exit;;
            * ) update_apt;
                sudo apt install rake;
                break;;
        esac
    done
    echo "~ Cloning git://github.com/github/hub.git"
    sudo git clone git://github.com/github/hub.git -b 1.12-stable /tmp/hub
    echo "~ Installing hub"
    cd /tmp/hub
    sudo rake install PREFIX=/usr/local
    cd -
}

# Generate a new SSH key, to be copied into Github (at the very least)
function setup_ssh_key() {
    if [ ! -f ${HOME}/.ssh/id_rsa.pub ]; then
        ssh-keygen
    fi

    if [ -f ${HOME}/.ssh/id_rsa.pub ]; then
        echo -e "Here is your public key:\n"
        cat ${HOME}/.ssh/id_rsa.pub
        echo -e "\nPlease copy it into:"
        echo -e "- Github (https://github.com/settings/ssh)"
        echo -e "- Launchpad (e.g.: https://launchpad.net/~nottrobin/+editsshkeys)"
    fi
}

# Run our setup-config script to setup the user's shell config
function setup_user_config() {
    if [ -f setup-user-config ]; then
        ./setup-user-config.sh
    elif [ -d ${HOME}/system-setup ]; then
        ${HOME}/system-setup/setup-user-config.sh;
    else
        while true; do
            read -p "Clone the system setup repository into ~/system-setup ? [Y/n] " clone_it
            case $clone_it in
                [Nn]* ) break;;
                * ) git clone git@github.com:nottrobin/system-setup.git ${HOME}/system-setup \
                    || git clone https://github.com/nottrobin/system-setup.git ${HOME}/system-setup;
                    ${HOME}/system-setup/setup-user-config.sh;
                    break;;
            esac
        done
    fi
}

run_functions="apt_always_yes install_chrome install_sublime_3 install_atom install_apt_packages install_github_hub setup_ssh_key setup_user_config"

for function_name in ${run_functions}; do
    while true; do
        read -p "Run "${function_name}"? [Y/n] " run_it
        case $run_it in
            [Nn]* ) break;;
            * ) eval ${function_name}; break;;
        esac
    done
done
