#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all the bashfiles.
for f in $BASEDIR/bashfiles/*.bash; do source $f; done
