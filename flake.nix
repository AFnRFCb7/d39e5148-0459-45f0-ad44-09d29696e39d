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
                                                                _config.visa.backend.server.fetch
                                                                _config.visa.frontend.web.fetch
                                                                _config.visa.frontend.admin.fetch
                                                                _config.visa.playwright.fetch
                                                                _config.visa.playwright.execute
                                                                _config.visa.backend.database.init
                                                            ] ;
                                                        environment.variables =
                                                            {
                                                                VISA_FETCH_NODE_SERVER = _config.visa.backend.server.fetch ;
                                                                VISA_FETCH_WEB = _config.visa.frontend.web.fetch ;
                                                                VISA_FETCH_ADMIN = _config.visa.frontend.admin.fetch ;
                                                                VISA_FETCH_PLAYWRIGHT = _config.visa.playwright.fetch ;
                                                                VISA_PACKAGE = _config.visa.playwright.package ;
                                                                VISA_PACKAGE_EXECUTE = _config.visa.playwright.execute ;
                                                                VISA_DB_INIT= _config.visa.backend.database.init ;
                                                            } ;
                                                        systemd.services =
                                                            {
                                                                visa-database =
                                                                    _lib.mkIf
                                                                        ( _config.visa.backend.enable && _config.visa.backend.database.server.enable )
                                                                        {
                                                                            after = [ "network.target" ] ;
                                                                            name = "${ _config.visa.backend.database.server.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStart =
                                                                                        let
                                                                                            application =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { state = { type = "temporary" ; } ; } ;
                                                                                                        name = "ExecStart" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = pkgs : [ pkgs.postgresql ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                postgres -h 127.0.0.1 -D /mounts/state -p ${ builtins.toString _config.visa.backend.database.server.port }
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/ExecStart" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                                visa-server =
                                                                    _lib.mkIf
                                                                        ( _config.visa.backend.enable && _config.visa.backend.server.enable )
                                                                        {
                                                                            after = [ "network.target" ] ;
                                                                            name = "${ _config.visa.backend.server.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStart =
                                                                                        let
                                                                                            application =
                                                                                                config.node-package.execute
                                                                                                    {
                                                                                                        command = "run start" ;
                                                                                                        name = "ExecStart" ;
                                                                                                        package = _config.visa.backend.server.package ;
                                                                                                        work-directory = "/tmp/sally" ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/ExecStart" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                            } ;
                                                    } ;
                                                options =
                                                    let
                                                        in
                                                            {
                                                                visa =
                                                                    {
                                                                        backend =
                                                                            {
                                                                                database =
                                                                                    {
                                                                                        init =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        _config.lazy-shell-application
                                                                                                            {
                                                                                                                mounts = { state = { source = "/tmp/state" ; type = "bind" ; } ; } ;
                                                                                                                name = "init" ;
                                                                                                                post = null ;
                                                                                                                runtime-inputs = pkgs : [ pkgs.postgresql ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        initdb --pgdata=/mounts/state
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    type = _lib.types.package ;
                                                                                                } ;
                                                                                        server =
                                                                                            {
                                                                                                enable = _lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name =
                                                                                                    _lib.mkOption
                                                                                                        {
                                                                                                            default = "visa-database" ;
                                                                                                            type = _lib.types.str ;
                                                                                                        } ;
                                                                                                port = _lib.mkOption { default = 18516 ; type = _lib.types.int ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                gateway =
                                                                                    {
                                                                                        enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                        name =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default = "visa-gateway" ;
                                                                                                    type = _lib.types.str ;
                                                                                                } ;
                                                                                    } ;
                                                                                server =
                                                                                    {
                                                                                        enable = _lib.mkOption { default = true ; type = _lib.types.bool ; } ;
                                                                                        fetch =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        _config.node-package.fetch
                                                                                                            {
                                                                                                                dependencies = { express = "^5.1.0" ; cors = "^2.8.6" ; } ;
                                                                                                                scripts = { start = "node server.js 14636" ; } ;
                                                                                                            } ;
                                                                                                    type = _lib.types.package ;
                                                                                                } ;
                                                                                        name =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default = "visa-server" ;
                                                                                                    type = _lib.types.str ;
                                                                                                } ;
                                                                                        package =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        _config.node-package.build ./backend/server ;
                                                                                                    type = _lib.types.package ;
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
                                                                                                                firefox = { source = _pkgs.firefox ; type = "ro-bind" ; } ;
                                                                                                                chromium = { source = _pkgs.chromium ; type = "ro-bind" ; } ;
                                                                                                                package = { source = _config.visa.playwright.package ; type = "ro-bind" ; } ;
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
                                                                                                                firefox = { source = _pkgs.firefox ; type = "ro-bind" ; } ;
                                                                                                                chromium = { source = _pkgs.chromium ; type = "ro-bind" ; } ;
                                                                                                                package = { source = _config.visa.playwright.package ; type = "ro-bind" ; } ;
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

