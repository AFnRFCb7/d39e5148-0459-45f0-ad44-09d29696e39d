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
                                                                                    EXECUTE_DB_MIGRATE=${ _config.visa.backend.database.migrate.environments.staging  }
                                                                                    EXECUTE_DB_INIT=${ _config.visa.backend.database.init }
                                                                                    EXECUTE_ADMIN=${ _config.visa.frontend.admin.fetch }
                                                                                    FETCH_FRONTEND=${ _config.visa.frontend.web.fetch }
                                                                                    FETCH_MIGRATE=${ _config.visa.backend.database.migrate.fetch }
                                                                                    PACKAGE_MIGRATE=${ _config.node-package.build ./backend/database/migrate }
                                                                                    DEMO_PLAYWRIGHT=${ _config.visa.playwright.demo }
                                                                                    PACKAGE=${ _config.visa.backend.server.environments.staging.package }
                                                                                    EOF
                                                                                '' ;
                                                                        }
                                                                )
                                                            ] ;
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
                                                                                                                initdb --pgdata=/mounts/state
                                                                                                                postgres -h 127.0.0.1 -D /mounts/state -p ${ builtins.toString _config.visa.backend.database.environments.staging.port } --unix-socket-directories=/mounts/socket
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/ExecStart" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                                visa-server-staging =
                                                                    _lib.mkIf
                                                                        ( _config.visa.backend.server.environments.staging.enable )
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
                                                                                                                                    package = { read-only = true ; source = _config.node-package.build ./backend/database ; type = "bind" ; } ;
                                                                                                                                } ;
                                                                                                                            name = "execute" ;
                                                                                                                            post = null ;
                                                                                                                            runtime-inputs = pkgs : [ pkgs.nodejs ] ;
                                                                                                                            text = text ;
                                                                                                                        } ;
                                                                                                                type = _lib.types.package ;
                                                                                                            } ;
                                                                                                in
                                                                                                    {
                                                                                                        staging =
                                                                                                            execute
                                                                                                                ''
                                                                                                                    cd /mounts/package
                                                                                                                    export DATABASE_HOST=localhost
                                                                                                                    export DATABASE_PORT=${ builtins.toString _config.visa.backend.database.environments.staging.port }
                                                                                                                    export DATABASE_DATABASE=visa
                                                                                                                    export DATABASE_USER=postgres
                                                                                                                    cat package.json
                                                                                                                    ${ _pkgs.findutils }/bin/find . -mindepth 1 -maxdepth 1
                                                                                                                    .bin/db-migrate --migrations-dir ./migrations/production up
                                                                                                                    .bin/db-migrate --migrations-dir ./migrations/staging up
                                                                                                                '' ;
                                                                                                    } ;
                                                                                        fetch =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        _config.node-package.fetch
                                                                                                            {
                                                                                                                name = "visa-database-migration" ;
                                                                                                                private = true ;
                                                                                                                dependencies =
                                                                                                                    {
                                                                                                                        db-migrate = "^0.11.14" ;
                                                                                                                        db-migrate-pg = "^1.5.2" ;
                                                                                                                    } ;
                                                                                                            } ;
                                                                                                    type = _lib.types.package ;
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
                                                                                                                        _config.node-package.execute
                                                                                                                            {
                                                                                                                                command = "run start" ;
                                                                                                                                name = "execute" ;
                                                                                                                                package = _config.node-package.build ./backend/server ;
                                                                                                                            } ;
                                                                                                                    type = _lib.types.package ;
                                                                                                                } ;
                                                                                                        name = _lib.mkOption { default = "visa-server-staging" ; type = _lib.types.str ; } ;
                                                                                                        package = lib.mkOption { default = _config.node-package.build ./backend/server ; type = _lib.types.package ; } ;
                                                                                                    } ;
                                                                                            } ;
                                                                            } ;
                                                                    } ;
                                                                frontend =
                                                                    {
                                                                        admin =
                                                                            {
                                                                                fetch =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.node-package.fetch
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
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default = config.node-package.build ./frontend/web ;
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
                                                                                                _config.node-package.fetch
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
                                                                                            type = _lib.types.package ;
                                                                                        } ;
                                                                                package = _config.node-package.build ./frontend/web ;
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
                                                                                                        firefox = { read-only = true ; source = _pkgs.firefox ; type = "bind" ; } ;
                                                                                                        chromium = { read-only = true ; source = _pkgs.chromium ; type = "bind" ; } ;
                                                                                                        migrate = { read-only = true ; source = _config.node-package.build ./backend/database/migrate ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = _config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    pkgs :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.firefox
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        ${ _config.visa.backend.database.migrate.environments.staging }/bin/execute
                                                                                                        cd /mounts/package
                                                                                                        BROWSER=chromium HEADLESS=false node tests.js
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
                                                                                                        firefox = { read-only = true ; source = _pkgs.firefox ; type = "bind" ; } ;
                                                                                                        chromium = { read-only = true ; source = _pkgs.chromium ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = _config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    pkgs :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.firefox
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        export
                                                                                                        cd /mounts/package
                                                                                                        BROWSER=chromium HEADLESS=true node tests.js
                                                                                                        BROWSER=firefox HEADLESS=true node tests.js
                                                                                                    '' ;
                                                                                            } ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                        fetch =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        _config.node-package.fetch
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
                                                                                            };
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                        package =
                                                                            _lib.mkOption
                                                                                {
                                                                                    default = _config.node-package.build ./playwright ;
                                                                                    type = _lib.types.package ;
                                                                                } ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                            } ;
                        in
                            {
                                implementation = implementation ;
                                check = null ;
                            } ;
        } ;
}

