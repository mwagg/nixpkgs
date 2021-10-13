#!/usr/bin/env bash

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

type nix-env || sh <(curl -L https://github.com/numtide/nix-unstable-installer/releases/download/nix-2.4pre20210823_af94b54/install)

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

type home-manager || {
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs:$HOME/.nix-defexpr/channels"

  nix-shell '<home-manager>' -A install
}

SHELL_LINE="$HOME/.nix-profile/bin/fish"

grep -qF "$SHELL_LINE" "/etc/shells"  || echo "$SHELL_LINE" | sudo tee --append "/etc/shells"
chsh -s "$HOME/.nix-profile/bin/fish"
