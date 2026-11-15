nix-shell -p pkgs.nodejs_22 --run "API_PROXY_TARGET=http://192.168.1.135:8080 ./node_modules/.bin/vite --open /www/"
