{
    inputs = { } ;
    outputs = { self } :
	    {
	        lib =
	            {
	                config-identity ? x : x ,
	                implementation-identity ? x : x ,
	                lib-identity ? x : x ,
	                pkgs-identity ? x : x
                } :
                    let
                        implementation =
                            { config , lib , pkgs , ... } :
                                let
                                    _config = config-identity config ;
                                    _lib = lib-identity lib ;
                                    _pkgs = pkgs-identity pkgs ;
                                    in
                                        implementation-identity
                                            {
                                                config =
                                                    {
                                                        environment.systemPackages =
                                                            [
                                                                (
                                                                    _config.lazy-shell-application
                                                                        {
                                                                            mounts = { } ;
                                                                            name = "visa" ;
                                                                            post = null ;
                                                                            runtime-inputs = pkgs : [ pkgs.coreutils ] ;
                                                                            text =
                                                                                ''
                                                                                    cat <<EOF
                                                                                    EXECUTE_MIGRATE=${ _config.visa.backend.database.migrate.environments.staging.up }
                                                                                    EXECUTE_DB_MIGRATE=${ _config.visa.backend.database.migrate.environments.staging.up  }
                                                                                    EXECUTE_DB_INIT=${ _config.visa.backend.database.init }
                                                                                    EXECUTE_ADMIN=${ _config.visa.frontend.admin.fetch }
                                                                                    FETCH_BACKEND=${ _config.visa.backend.server.fetch }
                                                                                    FETCH_FRONTEND=${ _config.visa.frontend.web.fetch }
                                                                                    FETCH_MIGRATE=${ _config.visa.backend.database.migrate.fetch }
                                                                                    PACKAGE_MIRATE=${ _config.visa.backend.database.migrate.package }
                                                                                    DEMO_PLAYWRIGHT=${ _config.visa.playwright.demo }
                                                                                    EXECUTE_PLAYWRIGHT=${ _config.visa.playwright.execute }
                                                                                    FETCH_SERVER=${ _config.visa.backend.server.fetch }
                                                                                    FETCH_ADMIN=${ _config.visa.frontend.admin.fetch }
                                                                                    PACKAGE_ADMIN=${ _config.visa.frontend.admin.package }
                                                                                    PACKAGE_SERVER=${ _config.visa.backend.server.package }
                                                                                    FETCH_WEB=${ _config.visa.frontend.web.fetch }
                                                                                    PACKAGE_WEB=${ _config.visa.frontend.web.package }
                                                                                    FETCH_PLAYWRIGHT=${ _config.visa.playwright.fetch }
                                                                                    PACKAGE_PLAYWRIGHT=${ _config.visa.playwright.package }
                                                                                    EOF
                                                                                '' ;
                                                                        }
                                                                )
                                                            ] ;
                                                            services.nginx =
                                                                {
                                                                    enable = true ;
                                                                    virtualHosts."visa-staging.com".locations =
                                                                        {
                                                                            "/" =
                                                                                _lib.mkIf
                                                                                    config.visa.backend.server.environments.staging.enable
                                                                                    {
                                                                                        proxyPass =
                                                                                            "http://${ _config.visa.backend.server.environments.staging.host }:${ builtins.toString _config.visa.backend.server.environments.staging.port }" ;
                                                                                    } ;
                                                                            "/admin/" =
                                                                                _lib.mkIf
                                                                                    config.visa.frontend.admin.environments.staging.enable
                                                                                    {
                                                                                        root = _config.visa.frontend.admin.package ;
                                                                                        tryFiles = "$uri $uri/ /admin/index.html" ;
                                                                                    } ;
                                                                        } ;
                                                                } ;
                                                        systemd.services =
                                                            {
#                                                                visa-archive-staging =
#                                                                    _lib.mkIf
#                                                                        _config.visa.backend.database.environments.staging.server.enable
#                                                                        {
#                                                                            after = [ "network.target" ] ;
#                                                                            name = "${ _config.visa.backend.database.environments.staging.name }.service" ;
#                                                                            serviceConfig =
#                                                                                {
#                                                                                    DynamicUser = true ;
#                                                                                } ;
#                                                                            wantedBy = [ "multi-user.target" ] ;
#                                                                        } ;
                                                                visa-database-staging =
                                                                    _lib.mkIf
                                                                        _config.visa.backend.database.environments.staging.enable
                                                                        {
                                                                            after = [ "network.target" "local-fs.target" ] ;
                                                                            name = "${ _config.visa.backend.database.environments.staging.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStartPost = "${ _config.visa.backend.database.migrate.environments.staging.up }/bin/execute" ;
                                                                                    ExecStart =
                                                                                        let
                                                                                            application =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { socket = { type = "temporary" ; } ; state = { type = "temporary" ; } ; } ;
                                                                                                        name = "ExecStart" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = pkgs : [ pkgs.postgresql ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                initdb --pgdata=/mounts/state --username postgres
                                                                                                                postgres -h 127.0.0.1 -D /mounts/state -p ${ builtins.toString _config.visa.backend.database.environments.staging.port } --unix-socket-directories=/mounts/socket
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/ExecStart" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                                visa-server-staging =
                                                                    _lib.mkIf _config.visa.backend.server.environments.staging.enable
                                                                        {
                                                                            after = [ "network.target" ] ;
                                                                            name = "${ _config.visa.backend.server.environments.staging.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStart = "${ _config.visa.backend.server.environments.staging.execute }/bin/execute" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                            } ;
                                                        virtualisation.vmVariant.virtualisation.qemu.networkingOptions =
                                                            _lib.mkForce
                                                                [
                                                                    "-device"
                                                                    "e1000,netdev=net0"
                                                                    "-netdev"
                                                                    "user,id=net0,hostfwd=tcp::8080-:80"
                                                                ] ;
                                                            networking.firewall.allowedTCPPorts = [ 80 ] ;
                                                    } ;
                                                options =
                                                    {
                                                        visa =
                                                            {
                                                                backend =
                                                                    {
                                                                        database =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        production =
                                                                                            {
                                                                                                enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                                name = _lib.mkOption { default = "visa-database-production" ; type = _lib.types.str ; } ;
                                                                                                port = _lib.mkOption { default = 16204 ; type = _lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                        staging =
                                                                                            {
                                                                                                enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                                name = _lib.mkOption { default = "visa-database-staging" ; type = _lib.types.str ; } ;
                                                                                                port = _lib.mkOption { default = 11187 ; type =_lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                init =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { home = { source = "/tmp" ; type = "bind" ; } ; } ;
                                                                                                        name = "init" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = pkgs : [ pkgs.postgresql ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                cd /mounts/home
                                                                                                                mkdir --parents visa
                                                                                                                initdb --pgdata=/mounts/home/visa
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                migrate =
                                                                                    {
                                                                                        environments =
                                                                                            let
                                                                                                execute =
                                                                                                    text :
                                                                                                        _lib.mkOption
                                                                                                            {
                                                                                                                default =
                                                                                                                    _config.lazy-shell-application
                                                                                                                        {
                                                                                                                            mounts =
                                                                                                                                {
                                                                                                                                    package = { read-only = true ; source = _config.visa.backend.database.migrate.package ; type = "bind" ; } ;
                                                                                                                                } ;
                                                                                                                            name = "execute" ;
                                                                                                                            post = null ;
                                                                                                                            runtime-inputs = pkgs : [ pkgs.postgresql pkgs.nodejs ] ;
                                                                                                                            text = text ;
                                                                                                                        } ;
                                                                                                                type = _lib.types.package ;
                                                                                                            } ;
                                                                                                in
                                                                                                    {
                                                                                                        staging =
                                                                                                            {
                                                                                                                down =
                                                                                                                    execute
                                                                                                                        ''
                                                                                                                            cd /mounts/package
                                                                                                                            export DATABASE_HOST=localhost
                                                                                                                            export DATABASE_PORT=${ builtins.toString _config.visa.backend.database.environments.staging.port }
                                                                                                                            export DATABASE_DATABASE=postgres
                                                                                                                            export DATABASE_USER=postgres
                                                                                                                            sleep 10s
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate down --migrations-dir ./migrations/staging
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate down --migrations-dir ./migrations/production --verbose
                                                                                                                        '' ;
                                                                                                                up =
                                                                                                                    execute
                                                                                                                        ''
                                                                                                                            cd /mounts/package
                                                                                                                            export DATABASE_HOST=localhost
                                                                                                                            export DATABASE_PORT=${ builtins.toString _config.visa.backend.database.environments.staging.port }
                                                                                                                            export DATABASE_DATABASE=postgres
                                                                                                                            export DATABASE_USER=postgres
                                                                                                                            sleep 10s
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate up --migrations-dir ./migrations/production --verbose
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate up --migrations-dir ./migrations/staging
                                                                                                                        '' ;
                                                                                                            } ;
                                                                                                    } ;
                                                                                        fetch =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        _config.lazy-shell-application
                                                                                                            {
                                                                                                                mounts =
                                                                                                                    {
                                                                                                                        pwd = { source = "." ; type = "bind" ; } ;
                                                                                                                    } ;
                                                                                                                name = "fetch" ;
                                                                                                                post = null ;
                                                                                                                runtime-inputs =
                                                                                                                    pkgs :
                                                                                                                        [
                                                                                                                            (
                                                                                                                                _config.tree-serialization.explode
                                                                                                                                    {
                                                                                                                                        bytes = "1m" ;
                                                                                                                                        input = "/mounts/pwd/node_modules" ;
                                                                                                                                        name = "explode" ;
                                                                                                                                        output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                                    }
                                                                                                                            )
                                                                                                                            pkgs.git
                                                                                                                            pkgs.nodejs
                                                                                                                        ] ;
                                                                                                                text =
                                                                                                                    let
                                                                                                                        package =
                                                                                                                            {
                                                                                                                                name = "visa-database-migration" ;
                                                                                                                                private = true ;
                                                                                                                                dependencies =
                                                                                                                                    {
                                                                                                                                        db-migrate = "^0.11.14" ;
                                                                                                                                        db-migrate-pg = "^1.5.2" ;
                                                                                                                                    } ;
                                                                                                                            } ;
                                                                                                                        in
                                                                                                                            ''
                                                                                                                                MESSAGE="$1"
                                                                                                                                git clean -fd
                                                                                                                                cat ${ builtins.toFile "package.json" ( builtins.toJSON package ) } > package.json
                                                                                                                                git rm -r --ignore-unmatch node_modules node_modules.exploded
                                                                                                                                mkdir --parents node_modules.exploded
                                                                                                                                npm install
                                                                                                                                explode
                                                                                                                                git add node_modules.exploded
                                                                                                                                git clean -fd
                                                                                                                                git commit -am "$MESSAGE" --allow-empty --allow-empty-message
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    type = _lib.types.package ;
                                                                                                } ;
                                                                                        package =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        let
                                                                                                            code = ./. ;
                                                                                                            in
                                                                                                                _pkgs.runCommand
                                                                                                                    "package"
                                                                                                                    {
                                                                                                                        nativeBuildInputs =
                                                                                                                            [
                                                                                                                                (
                                                                                                                                    _pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "install-it" ;
                                                                                                                                            runtimeInputs = [ ( _config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    OUT="$1"
                                                                                                                                                    export OUT
                                                                                                                                                    mkdir --parents "$OUT/node_modules"
                                                                                                                                                    ln --symbolic "${ code }/backend/database/migrate/"* "$OUT"
                                                                                                                                                    mkdir --parents "$OUT/node_modules"
                                                                                                                                                    if [[ ! -e "$OUT/node_modules.exploded" ]]
                                                                                                                                                    then
                                                                                                                                                        mkdir --parents "$OUT/node_modules.exploded"
                                                                                                                                                    fi
                                                                                                                                                    implode
                                                                                                                                                    rm --recursive --force "$OUT/node_modules.exploded"
                                                                                                                                                '' ;
                                                                                                                                        }
                                                                                                                                )
                                                                                                                            ] ;
                                                                                                                    }
                                                                                                                    ''install-it "$out"'' ;
                                                                                                    type = _lib.types.package ;
                                                                                                } ;
                                                                                    } ;
                                                                            } ;
                                                                        gateway =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        staging =
                                                                                            {
                                                                                                enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                                name = _lib.mkOption { default = "visa-gateway-staging" ; type = _lib.types.str ; } ;
                                                                                                port = _lib.mkOption { default = 16204 ; type = _lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                            } ;
                                                                        server =
                                                                            {
                                                                                environments =
                                                                                    let
                                                                                        in
                                                                                            {
                                                                                                staging =
                                                                                                    {
                                                                                                        enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                                        execute =
                                                                                                            _lib.mkOption
                                                                                                                {
                                                                                                                    default =
                                                                                                                        _config.lazy-shell-application
                                                                                                                            {
                                                                                                                                mounts =
                                                                                                                                    {
                                                                                                                                        package = { read-only = true ; source = _config.visa.backend.server.package ; type = "bind" ; } ;
                                                                                                                                        standard-output = { is-directory = false ; source = "/tmp/standard-output" ; type = "bind" ; } ;
                                                                                                                                    } ;
                                                                                                                                name = "execute" ;
                                                                                                                                post = null ;
                                                                                                                                runtime-inputs = pkgs : [ pkgs.coreutils pkgs.nodejs ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        cd /mounts/package
                                                                                                                                        export OUTPUT=/mounts/standard-output
                                                                                                                                        node /mounts/package/server.js ${ builtins.toString _config.visa.backend.server.environments.staging.port }
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    type = _lib.types.package ;
                                                                                                                } ;
                                                                                                        host = _lib.mkOption { default = "localhost" ; type = _lib.types.str ; } ;
                                                                                                        name = _lib.mkOption { default = "visa-server-staging" ; type = _lib.types.str ; } ;
                                                                                                        port = lib.mkOption { default = 14636 ; type =_lib.types.ints.between 1024 65535 ; } ;
                                                                                                    } ;
                                                                                            } ;
                                                                                fetch =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            pkgs :
                                                                                                                [
                                                                                                                    (
                                                                                                                        _config.tree-serialization.explode
                                                                                                                            {
                                                                                                                                bytes = "1m" ;
                                                                                                                                input = "/mounts/pwd/node_modules" ;
                                                                                                                                name = "explode" ;
                                                                                                                                output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.git
                                                                                                                    pkgs.nodejs
                                                                                                                ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                package =
                                                                                                                    {
                                                                                                                        dependencies =
                                                                                                                            {
                                                                                                                                cors = "^2.8.6" ;
                                                                                                                                express = "^5.1.0" ;
                                                                                                                                pg = "^8.16.3";
                                                                                                                            } ;
                                                                                                                    } ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        MESSAGE="$1"
                                                                                                                        git clean -fd
                                                                                                                        cat ${ builtins.toFile "package.json" ( builtins.toJSON package ) } > package.json
                                                                                                                        git rm -r --ignore-unmatch node_modules node_modules.exploded
                                                                                                                        mkdir --parents node_modules.exploded
                                                                                                                        npm install
                                                                                                                        explode
                                                                                                                        git add node_modules.exploded
                                                                                                                        git clean -fd
                                                                                                                        git commit -am "$MESSAGE" --allow-empty --allow-empty-message
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        _pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            _pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs =
                                                                                                                                        [
                                                                                                                                            (
                                                                                                                                                _config.tree-serialization.implode
                                                                                                                                                    {
                                                                                                                                                        input = "${ code }/backend/server/node_modules.exploded" ;
                                                                                                                                                        name = "implode" ;
                                                                                                                                                        output = "$OUT/node_modules" ;
                                                                                                                                                    }
                                                                                                                                            )
                                                                                                                                        ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            cp --recursive "${ code }/backend/server/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            implode
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                    } ;
                                                                frontend =
                                                                    {
                                                                        admin =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        staging =
                                                                                            {
                                                                                                enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                                name = _lib.mkOption { default = "visa-database-production" ; type = _lib.types.str ; } ;
                                                                                                port = _lib.mkOption { default = 16204 ; type = _lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                fetch =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            pkgs :
                                                                                                                [
                                                                                                                    (
                                                                                                                        _config.tree-serialization.explode
                                                                                                                            {
                                                                                                                                bytes = "1m" ;
                                                                                                                                input = "/mounts/pwd/node_modules" ;
                                                                                                                                name = "explode" ;
                                                                                                                                output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.git
                                                                                                                    pkgs.nodejs
                                                                                                                ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                package =
                                                                                                                    {
                                                                                                                        name = "visa" ;
                                                                                                                        version = "0.0.0" ;
                                                                                                                        private = true ;
                                                                                                                        type = "module" ;
                                                                                                                        scripts =
                                                                                                                            {
                                                                                                                                dev = "vite --port 11141" ;
                                                                                                                                build = "run-p type-check \"build-only {@}\" --" ;
                                                                                                                                preview = "vite preview" ;
                                                                                                                                "build-only" = "vite build" ;
                                                                                                                                "type-check" = "vue-tsc --build" ;
                                                                                                                            } ;
                                                                                                                        dependencies =
                                                                                                                            {
                                                                                                                                vue = "^3.5.42" ;
                                                                                                                                vue-router = "^5.3.1" ;
                                                                                                                            } ;
                                                                                                                        devDependencies =
                                                                                                                            {
                                                                                                                                "@tsconfig/node24" = "^24.0.5" ;
                                                                                                                                "@types/node" = "^24.13.4" ;
                                                                                                                                "@vitejs/plugin-vue" = "^6.0.8" ;
                                                                                                                                "@vue/tsconfig" = "^0.9.1" ;
                                                                                                                                "npm-run-all2" = "^9.0.3" ;
                                                                                                                                typescript = "~6.0.0" ;
                                                                                                                                vite = "^8.2.2" ;
                                                                                                                                "vite-plugin-vue-devtools" = "^8.2.1" ;
                                                                                                                                "vue-tsc" = "^3.3.11" ;
                                                                                                                            } ;
                                                                                                                        engines =
                                                                                                                            {
                                                                                                                                node = "^22.18.0 || >=24.12.0" ;
                                                                                                                            } ;
                                                                                                                    } ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        MESSAGE="$1"
                                                                                                                        git clean -fd
                                                                                                                        cat ${ builtins.toFile "package.json" ( builtins.toJSON package ) } > package.json
                                                                                                                        git rm -r --ignore-unmatch node_modules node_modules.exploded
                                                                                                                        mkdir --parents node_modules.exploded
                                                                                                                        npm install
                                                                                                                        explode
                                                                                                                        git add node_modules.exploded
                                                                                                                        git clean -fd
                                                                                                                        git commit -am "$MESSAGE" --allow-empty --allow-empty-message
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        _pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            _pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs = [ ( _config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT"
                                                                                                                                            cp --recursive "${ code }/frontend/admin/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            implode
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                        android = null ;
                                                                        web =
                                                                            {
                                                                                fetch =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            pkgs :
                                                                                                                [
                                                                                                                    (
                                                                                                                        _config.tree-serialization.explode
                                                                                                                            {
                                                                                                                                bytes = "1m" ;
                                                                                                                                input = "/mounts/pwd/node_modules" ;
                                                                                                                                name = "explode" ;
                                                                                                                                output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.git
                                                                                                                    pkgs.nodejs
                                                                                                                ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                package =
                                                                                                                    {
                                                                                                                        name = "visa" ;
                                                                                                                        version = "0.0.0" ;
                                                                                                                        private = true ;
                                                                                                                        type = "module" ;
                                                                                                                        scripts =
                                                                                                                            {
                                                                                                                                dev = "vite" ;
                                                                                                                                build = "run-p type-check \"build-only {@}\" --" ;
                                                                                                                                preview = "vite preview" ;
                                                                                                                                "build-only" = "vite build" ;
                                                                                                                                "type-check" = "vue-tsc --build" ;
                                                                                                                            } ;
                                                                                                                        dependencies =
                                                                                                                            {
                                                                                                                                vue = "^3.5.42" ;
                                                                                                                            } ;
                                                                                                                        devDependencies =
                                                                                                                            {
                                                                                                                                "@tsconfig/node24" = "^24.0.5" ;
                                                                                                                                "@types/node" = "^24.13.4" ;
                                                                                                                                "@vitejs/plugin-vue" = "^6.0.8" ;
                                                                                                                                "@vue/tsconfig" = "^0.9.1" ;
                                                                                                                                "npm-run-all2" = "^9.0.3" ;
                                                                                                                                typescript = "~6.0.0" ;
                                                                                                                                vite = "^8.2.2" ;
                                                                                                                                "vite-plugin-vue-devtools" = "^8.2.1" ;
                                                                                                                                "vue-tsc" = "^3.3.11" ;
                                                                                                                            } ;
                                                                                                                        engines =
                                                                                                                            {
                                                                                                                                node = "^22.18.0 || >=24.12.0" ;
                                                                                                                            } ;
                                                                                                                    } ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        MESSAGE="$1"
                                                                                                                        git clean -fd
                                                                                                                        cat ${ builtins.toFile "package.json" ( builtins.toJSON package ) } > package.json
                                                                                                                        git rm -r --ignore-unmatch node_modules node_modules.exploded
                                                                                                                        mkdir --parents node_modules.exploded
                                                                                                                        npm install
                                                                                                                        explode
                                                                                                                        git add node_modules.exploded
                                                                                                                        git clean -fd
                                                                                                                        git commit -am "$MESSAGE" --allow-empty --allow-empty-message
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        _pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            _pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs = [ ( _config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            ln --symbolic "${ code }/frontend/web/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            if [[ ! -e "$OUT/node_modules.exploded" ]]
                                                                                                                                            then
                                                                                                                                                mkdir --parents "$OUT/node_modules.exploded"
                                                                                                                                            fi
                                                                                                                                            implode
                                                                                                                                            rm --recursive --force "$OUT/node_modules.exploded"
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                    } ;
                                                                playwright =
                                                                    {
                                                                        demo =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        _config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        chromium = { read-only = true ; source = _pkgs.chromium ; type = "bind" ; } ;
                                                                                                        migrate = { read-only = true ; source = _config.visa.backend.database.migrate.package ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = _config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    pkgs :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        ${ _config.visa.backend.database.migrate.environments.staging.down }/bin/execute
                                                                                                        ${ _config.visa.backend.database.migrate.environments.staging.up }/bin/execute
                                                                                                        cd /mounts/package
                                                                                                        BROWSER=chromium HEADLESS=false node demo.js
                                                                                                    '' ;
                                                                                            } ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                        execute =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        _config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        chromium = { read-only = true ; source = _pkgs.chromium ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = _config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                        playwright = { type = "temporary" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    pkgs :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        cd /mounts/playwright
                                                                                                        cp --recursive "/mounts/package/." .
                                                                                                        export PATH="$PATH:/mounts/package/node_modules/.bin"
                                                                                                        cd /mounts/playwright
                                                                                                        ./node_modules/.bin/playwright test tests.spec.js
                                                                                                    '' ;
                                                                                            } ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                        fetch =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        _config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        pwd = { source = "." ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "fetch" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    pkgs :
                                                                                                        [
                                                                                                            (
                                                                                                                _config.tree-serialization.explode
                                                                                                                    {
                                                                                                                        bytes = "1m" ;
                                                                                                                        input = "/mounts/pwd/node_modules" ;
                                                                                                                        name = "explode" ;
                                                                                                                        output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                    }
                                                                                                            )
                                                                                                            pkgs.git
                                                                                                            pkgs.nodejs
                                                                                                        ] ;
                                                                                                text =
                                                                                                    let
                                                                                                        package =
                                                                                                            {
                                                                                                                name = "visa-playwright" ;
                                                                                                                version = "0.0.0" ;
                                                                                                                private = true ;
                                                                                                                scripts =
                                                                                                                    {
                                                                                                                        test = "playwright test" ;
                                                                                                                    } ;
                                                                                                                devDependencies =
                                                                                                                    {
                                                                                                                        "@playwright/test" = "^1.50.1" ;
                                                                                                                        "playwright" = "^1.50.1" ;
                                                                                                                    } ;
                                                                                                            } ;
                                                                                                        in
                                                                                                            ''
                                                                                                                MESSAGE="$1"
                                                                                                                git clean -fd
                                                                                                                cat ${ builtins.toFile "package.json" ( builtins.toJSON package ) } > package.json
                                                                                                                git rm -r --ignore-unmatch node_modules node_modules.exploded
                                                                                                                mkdir --parents node_modules.exploded
                                                                                                                npm install
                                                                                                                explode
                                                                                                                git add node_modules.exploded
                                                                                                                git clean -fd
                                                                                                                git commit -am "$MESSAGE" --allow-empty --allow-empty-message
                                                                                                            '' ;
                                                                                            } ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                        package =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        let
                                                                                            code = ./. ;
                                                                                            in
                                                                                                _pkgs.runCommand
                                                                                                    "package"
                                                                                                    {
                                                                                                        nativeBuildInputs =
                                                                                                            [
                                                                                                                (
                                                                                                                    _pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "install-it" ;
                                                                                                                            runtimeInputs = [ ( _config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    OUT="$1"
                                                                                                                                    export OUT
                                                                                                                                    mkdir --parents "$OUT/node_modules"
                                                                                                                                    cp --recursive "${ code }/playwright/"* "$OUT"
                                                                                                                                    mkdir --parents "$OUT/node_modules"
                                                                                                                                    implode
                                                                                                                                '' ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                    }
                                                                                                    ''install-it "$out"'' ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                            } ;
                        in
                            {
                                implementation = implementation ;
                                check =
                                    {
                                        failure ,
                                        lazy-shell-application ,
                                        nixosTest ,
                                        node-fetch ,
                                        node-package ,
                                        obviated-by ,
                                        tree-serialization ,
                                        visitor
                                    } :
                                        {
                                            obviated-by = obviated-by ;
                                            test =
                                                nixosTest
                                                    {
                                                        name = "visa" ;
                                                        nodes.client =
                                                            { config , pkgs , ... } :
                                                                let
                                                                    _config = config-identity config ;
                                                                    _pkgs = pkgs-identity pkgs ;
                                                                    in
                                                                        {
                                                                            config =
                                                                                {
                                                                                    environment.systemPackages =
                                                                                        [
                                                                                            (
                                                                                                _pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "execute-migrate" ;
                                                                                                        runtimeInputs = [ _config.visa.backend.database.migrate.environments.staging.up ] ;
                                                                                                        text = "execute" ;
                                                                                                    }
                                                                                            )
                                                                                            (
                                                                                                _pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "execute-playwright" ;
                                                                                                        runtimeInputs = [ _config.visa.playwright.execute ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                ${ _config.visa.playwright.execute }/bin/execute
                                                                                                            '' ;
                                                                                                    }
                                                                                            )
                                                                                        ] ;
                                                                                } ;
                                                                            imports = [ failure implementation lazy-shell-application node-fetch node-package visitor tree-serialization ] ;
                                                                        } ;
                                                        testScript =
                                                            ''
                                                                client.wait_for_unit("multi-user.target")
                                                                client.wait_for_unit("visa-database-staging.service")
                                                                client.wait_for_unit("visa-server-staging.service")
                                                                client.wait_for_unit("nginx.service")
                                                                client.succeed("execute-migrate")
                                                                client.succeed("execute-playwright")
                                                            '' ;
                                                    } ;
                                            type = "visa" ;
                                        } ;
                            } ;
        } ;
}