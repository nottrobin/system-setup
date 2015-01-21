set -e

scriptpath=$(readlink -f $0);
projectdir=`dirname "$scriptpath"`

# Add a new apt config setting
# to make it always install package dependencies
# without prompting "are you sure?"
function apt_always_yes() {
    if [ ! -d $projectdir ]; then
        echo "can't get current directory"
        return;
    fi

    if [ -d /etc/apt/apt.conf.d ] && [ ! -e /etc/apt/apt.conf.d/97always-yes ]; then
        echo "~ Linking apt config file 97always-yes"
        sudo ln -s ${projectdir}/.apt-always-yes.conf /etc/apt/apt.conf.d/97always-yes
    fi
}

# Download and install Google Chrome, as best we know how
function install_chrome() {
    echo "~ Installing Google Chrome's dependencies"
    sudo apt-get install libxss1 libappindicator1 libindicator7
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

# Install apt packages in the list
# Prompting each time 
function install_apt_packages() {
    install_packages="git python-dev vim byobu ack-grep"

    for package in ${install_packages}; do
        while true; do
            read -p "Install "${package}"? [Y/n] " install
            case $install in
                [Nn]* ) break;;
                * ) sudo apt install ${package}; break;;
            esac
        done
    done
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
        echo -e "- Launchpad (https://launchpad.net/~nottrobin/+editsshkeys)"
    fi
}

# Run our setup-config script to setup the user's shell config
function setup_user_config() {
    ./setup-user-config.sh
}

run_functions="apt_always_yes install_chrome install_sublime_3 install_apt_packages setup_user_config setup_ssh_key"

for function_name in ${run_functions}; do
    while true; do
        read -p "Run "${function_name}"? [Y/n] " run_it
        case $run_it in
            [Nn]* ) break;;
            * ) eval ${function_name}; break;;
        esac
    done
done
