#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

argv=( "$@" )
argv=( "${argv[@]/\'/\'\\\'\'}" )
argv=( "${argv[@]/#/\'}" )
argv=( "${argv[@]/%/\'}" )

export HIE=1

exec nix-shell --pure --run "hie ${argv[*]}"
