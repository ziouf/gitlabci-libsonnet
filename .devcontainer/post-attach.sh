#!/bin/bash
set -eu

# Re-configures git global and local configuration with includes
# https://github.com/microsoft/vscode-remote-release/issues/2084
for conf in .gitconfig.global .gitconfig.local; do
  if [ -f $conf ]; then
    echo "*** Parsing ${conf##.gitconfig.} Git configuration export"
    while IFS='=' read -r key value; do
      case "$key" in
      user.name | user.email | user.signingkey | commit.gpgsign)
        echo "Set Git config ${key}=${value}"
        git config --global "$key" "$value"
        ;;
      esac
    done <"$conf"
    rm -f "$conf"
  fi
done