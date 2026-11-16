#!/bin/sh

export NIX_CONFIG="access-tokens = github.com=$TOKEN"
nix-collect-garbage
time SYSTEM=$(nix build \
    .#nixosConfigurations.user.config.system.build.toplevel \
    --no-link \
    --print-out-paths)
time timeout 1h nix copy \
    --to ssh://root@13.184.230.173?ssh-key=/home/emory/.ssh/nixos2.pem \
    "$SYSTEM"
time ssh -i /home/emory/.ssh/nixos2.pem root@13.184.230.173 \
    "nix-env --profile /nix/var/nix/profiles/system --set $SYSTEM && \
     /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
