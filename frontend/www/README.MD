
nix shell nixpkgs#nodejs_22

npm install vite && API_PROXY_TARGET=http://192.168.1.135:8080 ./node_modules/.bin/vite --open /www/


nixos-rebuild build-vm --flake .#user --override-input visa path:./visa