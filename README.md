dotfiles
========

# Installation

Clone the repo and run `install.sh` to apply the dotfiles and other system
customizations.

## Script Loader

`bashfiles/` directory contains multiple bash scripts based on the purpose 
and domain. These files are sourced by adding a sourcing line in the default
`.bashrc` or `.bash_profile`. To disable all the changes, this sourcing line
can be removed.

**NOTE**: Some configs like `.gitconfig` constains a specific username for ease 
of use. They should be changed before use.
