#!/bin/sh

nix-shell --extra-experimental-features flakes -p pkgs.git -p pkgs.coreutils --run "time timeout 10h nice --adjustment 19 nixos-rebuild switch --flake /tmp/tmp.a5It3bW42w/d39e5148-0459-45f0-ad44-09d29696e39d/config#user"

