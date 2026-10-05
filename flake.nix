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
                                                            ] ;
                                                        environment.variables =
                                                            {
                                                                VISA_FETCH_NODE_SERVER = _config.visa.backend.server.fetch ;
                                                                VISA_FETCH_WEB = _config.visa.frontend.web.fetch ;
                                                                VISA_FETCH_ADMIN = _config.visa.frontend.admin.fetch ;
                                                                VISA_FETCH_PLAYWRIGHT = _config.visa.playwright.fetch ;
                                                                VISA_PACKAGE = _config.visa.playwright.package ;
                                                                VISA_PACKAGE_EXECUTE = _config.visa.playwright.execute ;
                                                            } ;
                                                        systemd.services =
                                                            {
    #                                                            visa-gateway =
    #                                                                lib.mkIf
    #                                                                    ( config.visa.backend.enable && config.visa.backend.gateway.enable )
    #                                                                    {
    #                                                                        after = [ "network.target" ] ;
    #                                                                        name = "${ config.visa.backend.gateway.name }" ;
    #                                                                        serviceConfig =
    #                                                                            {
    #                                                                                DynamicUser = true ;
    #                                                                                ExecStart =
    #                                                                                    let
    #                                                                                        application =
    #                                                                                            pkgs.writeShellApplication
    #                                                                                                {
    #                                                                                                    name = "ExecStart" ;
    #                                                                                                    runtimeInputs = [ ] ;
    #                                                                                                    text =
    #                                                                                                        ''
    #                                                                                                        '' ;
    #                                                                                                } ;
    #                                                                                        in "${ application }/bin/ExecStart" ;
    #                                                                                RuntimeDirectory = "visa" ;
    #                                                                            } ;
    #                                                                        wantedBy = [ "multiuser.target" ] ;
    #                                                                    } ;
                                                                visa-server =
                                                                    _lib.mkIf
                                                                        ( _config.visa.backend.enable && config.visa.backend.server.enable )
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
                                                                                    RuntimeDirectory = "sally" ;
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
                                                                                        enable = _lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                        name =
                                                                                            _lib.mkOption
                                                                                                {
                                                                                                    default = "visa-database" ;
                                                                                                    type = _lib.types.str ;
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
                                                                                execute =
                                                                                    _lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                _config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { package = { source = _config.visa.playwright.package ; type = "ro-bind" ; } ; } ;
                                                                                                        name = "execute" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = pkgs : [ pkgs.coreutils pkgs.findutils pkgs.nodejs ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                cd /mounts/package
                                                                                                                echo 4194846619193557
                                                                                                                cat package.json
                                                                                                                find . -maxdepth 1
                                                                                                                echo 6712735326832375
                                                                                                                node tests.js
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

