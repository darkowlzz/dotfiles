#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
platform=$(uname)

function main_help() {
    cat << EOF
Installation help doc

usage: install.sh <command>

commands:
    basic   Apply basic shell configurations and auto-completion
    dev     Setup development configurations (git, vim)
    tools   Installs various tools (gnupg, tree, lpass)
    help    This help doc
EOF
}

# basic adds the config loader into the existing bashrc and installs bash-completion.
function install_basic() {
    echo
    echo "=== basic ==="

    # Install shell completion.
    bash_completion

    local bash_config_file

    # bash config is stored in .bash_profile in macOS.
    if [[ $platform == "Darwin" ]]; then
        bash_config_file=$HOME/.bash_profile
    elif [[ $platform == "Linux" ]]; then
        bash_config_file=$HOME/.bashrc
    fi

    # Add script loader to the default bashrc.
    local source_mybashrc
    source_mybashrc="source ${BASEDIR}/mybashrc.bash"
    if ! grep -F "$source_mybashrc" $bash_config_file; then
        echo $source_mybashrc >> $bash_config_file
    else
        echo "sourcing mybashrc.bash already exists in ${bash_config_file}"
    fi

    echo
    echo "NOTE: If completion isn't enabled automatically, enable it from ~/.bashrc"
}

# package_manager_check checks if a package manager is installed or not.
# If the platform specific package manager is not installed, quits the program.
function package_manager_check() {
    if [[ $platform == "Darwin" ]]; then
        if ! hash brew 2> /dev/null; then
            echo
            echo "brew not found, install brew and rerun the command"
            exit
        fi
    fi
}

# bash_completion installs bash-completion and downloads various completion scripts.
function bash_completion() {
    echo
    echo "=== bash_completion ==="

    package_manager_check

    # Install bash-completion
    if [[ $platform == "Darwin" ]]; then
        brew install bash-completion
        completionPath="$(brew --prefix)/etc/bash_completion.d"
    elif [[ $platform == "Linux" ]]; then
        apt-get update
        # Ubuntu docker image comes without curl.
        apt-get install curl bash-completion
        completionPath="/etc/bash_completion.d"
    fi

    # Install git-completion.
    local git_completion_path
    git_completion_path=${completionPath}/git-completion.bash
    if [[ ! -f $git_completion_path ]]; then
        curl -o $git_completion_path https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    else
        echo "git-completion.bash exists";
    fi

    # Add more completion scripts below.
}

# dev installs development tools and configurations.
function install_dev() {
    echo
    echo "=== dev env setup ==="

    # Install git, neovim
    if [[ $platform == "Darwin" ]]; then
        brew install git neovim
    elif [[ $platform == "Linux" ]]; then
        # Before adding PPA for neovim
        apt-get install software-properties-common --fix-missing
        add-apt-repository ppa:neovim-ppa/stable
        apt-get update
        apt-get install git neovim
    fi

    gitconfig
    neovim_config
    vimconfig

    echo
    echo "Development environment ready!"
}

function neovim_config() {
    echo "Linking neovim config to vimrc"
    mkdir -p ~/.config/nvim/
    cat > ~/.config/nvim/init.vim << EOF
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
    vim +PluginInstall +qall
}

# gitconfig creates symlinks of gitconfig and gitignore files in $HOME.
# This would overwrite any existing gitconfig and gitignore.
function gitconfig() {
    echo "Setting up gitconfig"
    ln -sf ${BASEDIR}/gitconfig ~/.gitconfig

    echo "Setting up gitignore"
    ln -sf ${BASEDIR}/gitignore ~/.gitignore
}

# vimconfig creates symlink of vimrc and installs vundle plugin manager and all
# the plugins.
function vimconfig() {
    echo "Setting up vimrc"
    ln -sf ${BASEDIR}/vimrc ~/.vimrc

    echo "Installing Vundle";
    if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    else
        echo "Vundle already cloned at ~/.vim/bundle/Vundle.vim"
    fi

    # Install vim plugins.
    echo "Installing vim plugins";
    nvim +PluginInstall +qall
}

# install_tools installs various tools for day-to-day needs.
function install_tools() {
    # Install gnupg, tree, lpass
    if [[ $platform == "Darwin" ]]; then
        brew install gnupg2 tree lastpass-cli --with-pinentry
    elif [[ $platform == "Linux" ]]; then
        # lpass has to be built manually.
        apt-get install gnupg2 tree
    fi
}

function main() {
    local confirm

    # If there's no argument, print the main help.
    if [ $# == 0 ]; then
        main_help
        exit
    fi

    # Parse the commandline args
    while test $# -gt 0
    do
        case "$1" in
            basic)
                echo "Basic shell customization would be applied. Continue?(y/N)"
                read confirm
                if [ $confirm == "y" ]; then
                    echo "Applying bash configurations..."
                    install_basic
                fi
                ;;
            dev)
                echo "Development configurations would be applied and development tools would be installed. Continue?(y/N)"
                read confirm
                if [ $confirm == "y" ]; then
                    echo "Setting up dev env..."
                    install_dev
                fi
                ;;
            tools)
                install_tools
                ;;
            *)
                main_help
                ;;
        esac
        # Shift the argument after use.
        shift
    done
}


main "$@"
