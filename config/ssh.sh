#!/bin/sh

ssh -i ~/.ssh/nixos2.pem root@13.184.230.173 "nix-shell --extra-experimental-features flakes -p pkgs.git --run \"date && time timeout 10h nice --adjustment 19 nixos-rebuild switch --flake /tmp/tmp.a5It3bW42w/d39e5148-0459-45f0-ad44-09d29696e39d/config#user\" && date"
