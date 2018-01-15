#!/bin/bash

# lpass helpers 
# http://lastpass.github.io/lastpass-cli/lpass.1.html

# Copy password to clipboard.
lpget() {
  lpass show -c --password $1
  echo "copied $1 secret to clipboard"
}

# Copy username to clipboard.
lpuser() {
  lpass show -c --username $1
}

# Search for name.
lpsearch() {
  lpass ls | grep -i $1
}

# Search and copy password to clipboard.
# Where there are multiple results of a search, the second argument can be
# passed to select any specific result by result index number.
# example: lpsg github.com 3
# If there are 3 results for github.com, the 3rd one would be selected.
lpsg() {
  lpget $(lpsearch $1 | sed -n $2p)
}
