{
    inputs = { } ;
    outputs = { self } :
	    {
	        lib =
	            { input ? null , output ? null } :
                    let
                        implementation =
                            { config , lib , pkgs , ... } @module :
                                let
                                    identified =
                                        if builtins.typeOf input == "lambda" then input module
                                        else if builtins.typeOf input == "null" then module
                                        else builtins.throw "7406564910795703" ;
                                    in
                                        with identified ;
                                            {
                                                config =
                                                    {
                                                        environment.systemPackages =
                                                            [
                                                                (
                                                                    config.lazy-shell-application
                                                                        {
                                                                            mounts = { } ;
                                                                            name = "visa" ;
                                                                            post = null ;
                                                                            runtime-inputs = { pkgs , ... } : [ pkgs.coreutils ] ;
                                                                            text =
                                                                                ''
                                                                                    cat <<EOF
                                                                                    EXECUTE_MIGRATE=${ config.visa.backend.database.migrate.environments.staging.up }
                                                                                    EXECUTE_DB_MIGRATE=${ config.visa.backend.database.migrate.environments.staging.up  }
                                                                                    EXECUTE_DB_INIT=${ config.visa.backend.database.init }
                                                                                    EXECUTE_ADMIN=${ config.visa.frontend.admin.fetch }
                                                                                    FETCH_BACKEND=${ config.visa.backend.server.fetch }
                                                                                    FETCH_FRONTEND=${ config.visa.frontend.web.fetch }
                                                                                    FETCH_MIGRATE=${ config.visa.backend.database.migrate.fetch }
                                                                                    PACKAGE_MIRATE=${ config.visa.backend.database.migrate.package }
                                                                                    DEMO_PLAYWRIGHT=${ config.visa.playwright.demo }
                                                                                    EXECUTE_PLAYWRIGHT=${ config.visa.playwright.execute }
                                                                                    FETCH_SERVER=${ config.visa.backend.server.fetch }
                                                                                    FETCH_ADMIN=${ config.visa.frontend.admin.fetch }
                                                                                    PACKAGE_ADMIN=${ config.visa.frontend.admin.package }
                                                                                    PACKAGE_SERVER=${ config.visa.backend.server.package }
                                                                                    FETCH_WEB=${ config.visa.frontend.web.fetch }
                                                                                    PACKAGE_WEB=${ config.visa.frontend.web.package }
                                                                                    FETCH_PLAYWRIGHT=${ config.visa.playwright.fetch }
                                                                                    PACKAGE_PLAYWRIGHT=${ config.visa.playwright.package }
                                                                                    FETCH_WWW=${ config.visa.frontend.www.fetch }
                                                                                    CODEGEN=${ config.visa.playwright.codegen }
                                                                                    EOF
                                                                                '' ;
                                                                            variables = { } ;
                                                                        }
                                                                )
                                                            ] ;
                                                            services.nginx =
                                                                {
                                                                    enable = true ;
                                                                    virtualHosts."visa-staging.com".locations =
                                                                        {
                                                                            "/" =
                                                                                lib.mkIf
                                                                                    config.visa.backend.server.environments.staging.enable
                                                                                    {
                                                                                        proxyPass = "http://${ config.visa.backend.server.environments.staging.host }:${ builtins.toString config.visa.backend.server.environments.staging.port }" ;
                                                                                    } ;
                                                                            "/admin/" =
                                                                                lib.mkIf
                                                                                    config.visa.frontend.admin.environments.staging.enable
                                                                                    {
                                                                                        alias = "${ config.visa.frontend.admin.package }/dist/" ;
                                                                                        index = "index.html" ;
                                                                                        tryFiles = "$uri $uri/ /admin/index.html" ;
                                                                                    } ;
                                                                            "/www/" =
                                                                                lib.mkIf
                                                                                    config.visa.frontend.www.environments.staging.enable
                                                                                    {
                                                                                        alias = "${ config.visa.frontend.www.package }/dist/" ;
                                                                                        index = "index.html" ;
                                                                                        tryFiles = "$uri $uri/ /www/index.html" ;
                                                                                    } ;
                                                                        } ;
                                                                } ;
                                                        systemd.services =
                                                            {
#                                                                visa-archive-staging =
#                                                                    lib.mkIf
#                                                                        config.visa.backend.database.environments.staging.server.enable
#                                                                        {
#                                                                            after = [ "network.target" ] ;
#                                                                            name = "${ config.visa.backend.database.environments.staging.name }.service" ;
#                                                                            serviceConfig =
#                                                                                {
#                                                                                    DynamicUser = true ;
#                                                                                } ;
#                                                                            wantedBy = [ "multi-user.target" ] ;
#                                                                        } ;
                                                                visa-database-staging =
                                                                    lib.mkIf
                                                                        config.visa.backend.database.environments.staging.enable
                                                                        {
                                                                            after = [ "network.target" "local-fs.target" ] ;
                                                                            name = "${ config.visa.backend.database.environments.staging.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStartPost = "${ config.visa.backend.database.migrate.environments.staging.up }/bin/up" ;
                                                                                    ExecStart =
                                                                                        let
                                                                                            application =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { socket = { type = "temporary" ; } ; state = { type = "temporary" ; } ; } ;
                                                                                                        name = "ExecStart" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = { pkgs , ... } : [ pkgs.postgresql ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                initdb --pgdata=/mounts/state --username postgres
                                                                                                                postgres -h 127.0.0.1 -D /mounts/state -p ${ builtins.toString config.visa.backend.database.environments.staging.port } --unix-socket-directories=/mounts/socket
                                                                                                            '' ;
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/ExecStart" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                                visa-server-staging =
                                                                    lib.mkIf config.visa.backend.server.environments.staging.enable
                                                                        {
                                                                            after = [ "network.target" ] ;
                                                                            name = "${ config.visa.backend.server.environments.staging.name }.service" ;
                                                                            serviceConfig =
                                                                                {
                                                                                    DynamicUser = true ;
                                                                                    ExecStart = "${ config.visa.backend.server.environments.staging.execute }/bin/execute" ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                            } ;
                                                        virtualisation.vmVariant.virtualisation.qemu.networkingOptions =
                                                            lib.mkForce
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
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name = lib.mkOption { default = "visa-database-production" ; type = lib.types.str ; } ;
                                                                                                port = lib.mkOption { default = 16204 ; type = lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                        staging =
                                                                                            {
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name = lib.mkOption { default = "visa-database-staging" ; type = lib.types.str ; } ;
                                                                                                port = lib.mkOption { default = 11187 ; type =lib.types.ints.between 1024 65535 ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                init =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts = { home = { source = "/tmp" ; type = "bind" ; } ; } ;
                                                                                                        name = "init" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs = { pkgs , ... } : [ pkgs.postgresql ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                cd /mounts/home
                                                                                                                mkdir --parents visa
                                                                                                                initdb --pgdata=/mounts/home/visa
                                                                                                            '' ;
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                                migrate =
                                                                                    {
                                                                                        environments =
                                                                                            let
                                                                                                execute =
                                                                                                    name : text :
                                                                                                        lib.mkOption
                                                                                                            {
                                                                                                                default =
                                                                                                                    config.lazy-shell-application
                                                                                                                        {
                                                                                                                            mounts =
                                                                                                                                {
                                                                                                                                    package = { read-only = true ; source = config.visa.backend.database.migrate.package ; type = "bind" ; } ;
                                                                                                                                } ;
                                                                                                                            name = name ;
                                                                                                                            post = null ;
                                                                                                                            runtime-inputs = { pkgs , ... } : [ pkgs.postgresql pkgs.nodejs ] ;
                                                                                                                            text = text ;
                                                                                                                            variables = { } ;
                                                                                                                        } ;
                                                                                                                type = lib.types.package ;
                                                                                                            } ;
                                                                                                in
                                                                                                    {
                                                                                                        staging =
                                                                                                            {
                                                                                                                down =
                                                                                                                    execute
                                                                                                                        "down"
                                                                                                                        ''
                                                                                                                            cd /mounts/package
                                                                                                                            export DATABASE_HOST=localhost
                                                                                                                            export DATABASE_PORT=${ builtins.toString config.visa.backend.database.environments.staging.port }
                                                                                                                            export DATABASE_DATABASE=postgres
                                                                                                                            export DATABASE_USER=postgres
                                                                                                                            sleep 10s
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate down --migrations-dir ./migrations/staging
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate down --migrations-dir ./migrations/production --verbose
                                                                                                                        '' ;
                                                                                                                up =
                                                                                                                    execute
                                                                                                                        "up"
                                                                                                                        ''
                                                                                                                            cd /mounts/package
                                                                                                                            export DATABASE_HOST=localhost
                                                                                                                            export DATABASE_PORT=${ builtins.toString config.visa.backend.database.environments.staging.port }
                                                                                                                            export DATABASE_DATABASE=postgres
                                                                                                                            export DATABASE_USER=postgres
                                                                                                                            sleep 10s
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate up --migrations-dir ./migrations/production --verbose
                                                                                                                            /mounts/package/node_modules/.bin/db-migrate up --migrations-dir ./migrations/staging
                                                                                                                        '' ;
                                                                                                            } ;
                                                                                                    } ;
                                                                                        fetch =
                                                                                            lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        config.lazy-shell-application
                                                                                                            {
                                                                                                                mounts =
                                                                                                                    {
                                                                                                                        pwd = { source = "." ; type = "bind" ; } ;
                                                                                                                    } ;
                                                                                                                name = "fetch" ;
                                                                                                                post = null ;
                                                                                                                runtime-inputs =
                                                                                                                    { pkgs , ... } :
                                                                                                                        [
                                                                                                                            (
                                                                                                                                config.tree-serialization.explode
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
                                                                                                                variables = { } ;
                                                                                                            } ;
                                                                                                    type = lib.types.package ;
                                                                                                } ;
                                                                                        package =
                                                                                            lib.mkOption
                                                                                                {
                                                                                                    default =
                                                                                                        let
                                                                                                            code = ./. ;
                                                                                                            in
                                                                                                                pkgs.runCommand
                                                                                                                    "package"
                                                                                                                    {
                                                                                                                        nativeBuildInputs =
                                                                                                                            [
                                                                                                                                (
                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "install-it" ;
                                                                                                                                            runtimeInputs = [ ( config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
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
                                                                                                    type = lib.types.package ;
                                                                                                } ;
                                                                                    } ;
                                                                            } ;
                                                                        gateway =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        staging =
                                                                                            {
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name = lib.mkOption { default = "visa-gateway-staging" ; type = lib.types.str ; } ;
                                                                                                port = lib.mkOption { default = 16204 ; type = lib.types.ints.between 1024 65535 ; } ;
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
                                                                                                        enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                        execute =
                                                                                                            lib.mkOption
                                                                                                                {
                                                                                                                    default =
                                                                                                                        config.lazy-shell-application
                                                                                                                            {
                                                                                                                                mounts =
                                                                                                                                    {
                                                                                                                                        package = { read-only = true ; source = config.visa.backend.server.package ; type = "bind" ; } ;
                                                                                                                                        standard-output = { is-directory = false ; source = 1 ; type = "pipe" ; } ;
                                                                                                                                    } ;
                                                                                                                                name = "execute" ;
                                                                                                                                post = null ;
                                                                                                                                runtime-inputs = { pkgs , ... } : [ pkgs.coreutils pkgs.nodejs ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        cd /mounts/package
                                                                                                                                        export OUTPUT=/mounts/standard-output
                                                                                                                                        export SESSION_SECRET="${ builtins.toString config.visa.backend.server.environments.staging.name }"
                                                                                                                                        node /mounts/package/server.js ${ builtins.toString config.visa.backend.server.environments.staging.port }
                                                                                                                                    '' ;
                                                                                                                                variables = { } ;
                                                                                                                            } ;
                                                                                                                    type = lib.types.package ;
                                                                                                                } ;
                                                                                                        host = lib.mkOption { default = "localhost" ; type = lib.types.str ; } ;
                                                                                                        name = lib.mkOption { default = "visa-server-staging" ; type = lib.types.str ; } ;
                                                                                                        port = lib.mkOption { default = 14636 ; type =lib.types.ints.between 1024 65535 ; } ;
                                                                                                    } ;
                                                                                            } ;
                                                                                fetch =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            { pkgs , ... } :
                                                                                                                [
                                                                                                                    (
                                                                                                                        config.tree-serialization.explode
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
                                                                                                                                bcrypt = "^5.1.1" ;
                                                                                                                                cors = "^2.8.6" ;
                                                                                                                                express = "^5.1.0" ;
                                                                                                                                "express-session" = "^1.18.2" ;
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
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    auth =
                                                                                                        [
                                                                                                            {
                                                                                                                config =
                                                                                                                    {
                                                                                                                        fields =
                                                                                                                            {
                                                                                                                                email = { type = "email" ; required = true ; } ;
                                                                                                                                password = { type = "password" ; required = true ; } ;
                                                                                                                            } ;
                                                                                                                        submit = "Log in" ;
                                                                                                                        url = "/api/auth/password/login" ;
                                                                                                                    } ;
                                                                                                                enabled = true ;
                                                                                                                id = "password" ;
                                                                                                                label = "Email and Password" ;
                                                                                                                type = "credentials" ;
                                                                                                            }
                                                                                                        ] ;
                                                                                                    code = ./. ;
                                                                                                    i18n =
                                                                                                        {
                                                                                                            common =
                                                                                                                {
                                                                                                                    contact =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "contact details" ;
                                                                                                                                "zh-CN" = "联系方式" ;
                                                                                                                            } ;
                                                                                                                    copyright =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "copyright" ;
                                                                                                                                "zh-CN" = "版权所有" ;
                                                                                                                            } ;
                                                                                                                    privacy =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "privacy page" ;
                                                                                                                                "zh-CN" = "隐私政策" ;
                                                                                                                            } ;
                                                                                                                    "Visa Solutions" =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "name of the business" ;
                                                                                                                                "zh-CN" = "签证通" ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                            control =
                                                                                                                {
                                                                                                                    Admin =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                zh-CN = "管理后台" ;
                                                                                                                            } ;
                                                                                                                    Home =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                zh-CN = "首页" ;
                                                                                                                            } ;
                                                                                                                    User =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "用户" ;
                                                                                                                            } ;
                                                                                                                    "Log In" =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "登录" ;
                                                                                                                            } ;
                                                                                                                    "Log Out" =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                zh-CN = "退出登录" ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                            narrative =
                                                                                                                {
                                                                                                                    home =
                                                                                                                        {
                                                                                                                            build =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Build your future." ;
                                                                                                                                        zh-CN = "创造你的未来" ;
                                                                                                                                    } ;
                                                                                                                            choose-the-path =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Choose the path that fits where you are going next." ;
                                                                                                                                        zh-CN = "选择适合您下一步旅程的路径" ;
                                                                                                                                    } ;
                                                                                                                            Explore =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        zh-CN = "探索" ;
                                                                                                                                    } ;
                                                                                                                            farther =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Go farther!" ;
                                                                                                                                        zh-CN = "走得更远" ;
                                                                                                                                    } ;
                                                                                                                            get-started =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Get Started" ;
                                                                                                                                        zh-CN = "立即开始" ;
                                                                                                                                    } ;
                                                                                                                            journey =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Your journey starts here" ;
                                                                                                                                        zh-CN = "您的旅程从这里开始" ;
                                                                                                                                    } ;
                                                                                                                            journeys =
                                                                                                                                {
                                                                                                                                    move =
                                                                                                                                        {
                                                                                                                                            description =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Navigate the journey of build a life in another country" ;
                                                                                                                                                        zh-CN = "开启在异国他乡建立新生活的旅程。" ;
                                                                                                                                                    } ;
                                                                                                                                            subtitle =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Start a new chapter" ;
                                                                                                                                                        zh-CN = "开启人生新篇章" ;
                                                                                                                                                    } ;
                                                                                                                                            title =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Move" ;
                                                                                                                                                        zh-CN = "移居" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                    study =
                                                                                                                                        {
                                                                                                                                            description =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Discover opportunities in the United States, Canada, Austraila to study at universities abroad." ;
                                                                                                                                                        zh-CN = "探索在美国、加拿大和澳大利亚的大学留学机会。" ;
                                                                                                                                                    } ;
                                                                                                                                            subtitle =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Build your future" ;
                                                                                                                                                        zh-CN = "开启未来之路" ;
                                                                                                                                                    } ;
                                                                                                                                            title =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Study" ;
                                                                                                                                                        zh-CN = "留学" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                    travel =
                                                                                                                                        {
                                                                                                                                            description =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Plan your next international trip with confidence." ;
                                                                                                                                                        zh-CN = "自信满满地规划您的下一次国际旅行。" ;
                                                                                                                                                    } ;
                                                                                                                                            subtitle =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Explore the world" ;
                                                                                                                                                        zh-CN = "探索世界" ;
                                                                                                                                                    } ;
                                                                                                                                            title =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        en-US = "Travel" ;
                                                                                                                                                        zh-CN = "旅行" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                } ;
                                                                                                                            options =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Explore your options" ;
                                                                                                                                        zh-CN = "探索您的选择" ;
                                                                                                                                    } ;
                                                                                                                            "Request Consultation" =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        zh-CN = "预约咨询" ;
                                                                                                                                    } ;
                                                                                                                            question =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "Whether you're traveling, studying, or starting a new life abroad, we're here to help you navigate the journey." ;
                                                                                                                                        zh-CN = "无论您是出国旅行、留学，还是开启海外新生活，我们都将竭诚为您提供帮助，助您顺利踏上旅程。" ;
                                                                                                                                    } ;
                                                                                                                            what-is-your-journey =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        en-US = "What's your journey?" ;
                                                                                                                                        zh-CN = "您想开启怎样的旅程？" ;
                                                                                                                                    } ;
                                                                                                                        } ;
                                                                                                                } ;
                                                                                                            subject =
                                                                                                                {
                                                                                                                    Move =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "移居" ;
                                                                                                                            } ;
                                                                                                                    Study =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "留学" ;
                                                                                                                            } ;
                                                                                                                    Travel =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "旅行" ;
                                                                                                                            } ;
                                                                                                                    Visa =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                description = "" ;
                                                                                                                                "zh-CN" = "签证" ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                        } ;
                                                                                                    in
                                                                                                        pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs =
                                                                                                                                        [
                                                                                                                                            (
                                                                                                                                                config.tree-serialization.implode
                                                                                                                                                    {
                                                                                                                                                        input = "${ code }/backend/server/node_modules.exploded" ;
                                                                                                                                                        name = "implode" ;
                                                                                                                                                        output = "$OUT/node_modules" ;
                                                                                                                                                    }
                                                                                                                                            )
                                                                                                                                            ( pkgs.python3.withPackages ( ps: [ ps.fonttools ps.brotli ] ) )
                                                                                                                                            pkgs.findutils
                                                                                                                                            pkgs.noto-fonts-cjk-sans
                                                                                                                                        ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            cp --recursive "${ code }/backend/server/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            implode
                                                                                                                                            mkdir --parents "$OUT/data/i18n"
                                                                                                                                            ln --symbolic ${ builtins.toFile "en-US.json" ( builtins.toJSON ( config.visitor { } { lambda = path : value : let calculated = value null ; in if builtins.hasAttr "en-US" calculated then calculated.en-US else builtins.elemAt path ( ( builtins.length path ) - 1 ) ; } i18n ) ) } "$OUT/data/i18n/en-US.json"
                                                                                                                                            ln --symbolic ${ builtins.toFile "zh-CN.json" ( builtins.toJSON ( config.visitor { } { lambda = path : value : let identity = { zh-CN , ... } : zh-CN ; in identity ( value null ) ; } i18n ) ) } "$OUT/data/i18n/zh-CN.json"
                                                                                                                                            mkdir --parents "$OUT/temporary"
                                                                                                                                            cat "$OUT/data/i18n/en-US.json" "$OUT/data/i18n/zh-CN.json" > "$OUT/temporary/i18n.txt"
                                                                                                                                            mkdir --parents "$OUT/data/fonts"
                                                                                                                                            ln --symbolic ${ builtins.toFile "auth.json" ( builtins.toJSON auth ) } "$OUT/data/auth.json"
                                                                                                                                            pyftsubset \
                                                                                                                                              ${ pkgs.noto-fonts-cjk-sans }/share/fonts/opentype/noto-cjk/NotoSansCJK-VF.otf.ttc \
                                                                                                                                              --font-number=0 \
                                                                                                                                              --text-file="$OUT"/temporary/i18n.txt \
                                                                                                                                              --flavor=woff2 \
                                                                                                                                              --output-file="$OUT"/data/fonts/noto-sans-sc-test.woff2
                                                                                                                                            mkdir --parents "$OUT/data/playwright"
#                                                                                                                                            find ${ config.visa.playwright.package }/demos | while read -r INPUT'
#                                                                                                                                            do
#                                                                                                                                                npx playwright test "$INPUT" \
#                                                                                                                                                    --config "$config_file" \
#                                                                                                                                                    --video on \
#                                                                                                                                                    --workers 1
#                                                                                                                                            done
                                                                                                                                            rm --recursive --force "$OUT/temporary"
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = lib.types.package ;
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
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name = lib.mkOption { default = "visa-database-production" ; type = lib.types.str ; } ;
                                                                                                port = lib.mkOption { default = 16204 ; type = lib.types.ints.between 1024 65535 ; } ;
                                                                                                secret = lib.mkOption { default = 2894844631204373 ; type = lib.types.int ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                fetch =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            { pkgs , ... } :
                                                                                                                [
                                                                                                                    (
                                                                                                                        config.tree-serialization.explode
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
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs = [ ( config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) pkgs.coreutils pkgs.nodejs ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT"
                                                                                                                                            cp --recursive "${ code }/frontend/admin/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            implode
                                                                                                                                            cd "$OUT"
                                                                                                                                            find node_modules -type f -perm /111 \
                                                                                                                                                -exec bash -c '
                                                                                                                                                    for file do
                                                                                                                                                        IFS= read -r first < "$file" || continue
                                                                                                                                                        if [ "$first" = "#!/usr/bin/env node" ]; then
                                                                                                                                                            {
                                                                                                                                                                printf "#!%s/bin/env node\n" "$1"
                                                                                                                                                                tail -n +2 "$file"
                                                                                                                                                            } > "$file.tmp"
                                                                                                                                                            cat "$file.tmp" > "$file"
                                                                                                                                                            rm "$file.tmp"
                                                                                                                                                        fi
                                                                                                                                                    done
                                                                                                                                                ' _ "${pkgs.coreutils}" {} +
                                                                                                                                            "$OUT/node_modules/.bin/vue-tsc" --build
                                                                                                                                            "$OUT/node_modules/.bin/vite" build
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                        android = null ;
                                                                        web =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        staging =
                                                                                            {
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                fetch =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            { pkgs , ... } :
                                                                                                                [
                                                                                                                    (
                                                                                                                        config.tree-serialization.explode
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
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs = [ ( config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
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
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                        www =
                                                                            {
                                                                                environments =
                                                                                    {
                                                                                        staging =
                                                                                            {
                                                                                                enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                                name = lib.mkOption { default = "visa-database-production" ; type = lib.types.str ; } ;
                                                                                                port = lib.mkOption { default = 13136 ; type = lib.types.ints.between 1024 65535 ; } ;
                                                                                                secret = lib.mkOption { default = 9085721238099874 ; type = lib.types.int ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                                fetch =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                config.lazy-shell-application
                                                                                                    {
                                                                                                        mounts =
                                                                                                            {
                                                                                                                pwd = { source = "." ; type = "bind" ; } ;
                                                                                                            } ;
                                                                                                        name = "fetch" ;
                                                                                                        post = null ;
                                                                                                        runtime-inputs =
                                                                                                            { pkgs , ... } :
                                                                                                                [
                                                                                                                    (
                                                                                                                        config.tree-serialization.explode
                                                                                                                            {
                                                                                                                                bytes = "1m" ;
                                                                                                                                input = "/mounts/pwd/node_modules" ;
                                                                                                                                name = "explode" ;
                                                                                                                                output = "/mounts/pwd/node_modules.exploded" ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.git
                                                                                                                    pkgs.nodejs_22
                                                                                                                ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                package =
                                                                                                                    {
                                                                                                                        name = "visa" ;
                                                                                                                        version = "0.0.0" ;
                                                                                                                        private = true ;
                                                                                                                        type = "module" ;
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
                                                                                                                                vue-i18n = "^11.1.0" ;
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
                                                                                                        variables = { } ;
                                                                                                    } ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                                package =
                                                                                    lib.mkOption
                                                                                        {
                                                                                            default =
                                                                                                let
                                                                                                    code = ./. ;
                                                                                                    in
                                                                                                        pkgs.runCommand
                                                                                                            "package"
                                                                                                            {
                                                                                                                nativeBuildInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "install-it" ;
                                                                                                                                    runtimeInputs = [ ( config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) pkgs.coreutils pkgs.nodejs ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            export OUT
                                                                                                                                            mkdir --parents "$OUT"
                                                                                                                                            cp --recursive "${ code }/frontend/www/"* "$OUT"
                                                                                                                                            mkdir --parents "$OUT/node_modules"
                                                                                                                                            implode
                                                                                                                                            cd "$OUT"
                                                                                                                                            find node_modules -type f -perm /111 \
                                                                                                                                                -exec bash -c '
                                                                                                                                                    for file do
                                                                                                                                                        IFS= read -r first < "$file" || continue
                                                                                                                                                        if [ "$first" = "#!/usr/bin/env node" ]; then
                                                                                                                                                            {
                                                                                                                                                                printf "#!%s/bin/env node\n" "$1"
                                                                                                                                                                tail -n +2 "$file"
                                                                                                                                                            } > "$file.tmp"
                                                                                                                                                            cat "$file.tmp" > "$file"
                                                                                                                                                            rm "$file.tmp"
                                                                                                                                                        fi
                                                                                                                                                    done
                                                                                                                                                ' _ "${pkgs.coreutils}" {} +
                                                                                                                                            "$OUT/node_modules/.bin/vue-tsc" --build
                                                                                                                                            "$OUT/node_modules/.bin/vite" build
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                            }
                                                                                                            ''install-it "$out"'' ;
                                                                                            type = lib.types.package ;
                                                                                        } ;
                                                                            } ;
                                                                    } ;
                                                                playwright =
                                                                    {
                                                                        codegen =
                                                                            lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        chromium = { read-only = true ; source = pkgs.chromium ; type = "bind" ; } ;
                                                                                                        migrate = { read-only = true ; source = config.visa.backend.database.migrate.package ; type = "bind" ; } ;
                                                                                                        output = { delete = false ; read-only = false ; type = "temporary" ; } ;
                                                                                                        package = { read-only = true ; source = config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                        temporary = { read-only = false ; source = "/tmp" ; type = "bind" ; } ;
                                                                                                        writable = { read-only = false ; type = "temporary" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    { pkgs , ... } :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                            ( config.failure { } )
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        cd /mounts/package
                                                                                                        export PLAYWRIGHT_BROWSERS_PATH=/mounts/writable
                                                                                                        ./node_modules/.bin/playwright install chromium
                                                                                                        export LDlibRARY_PATH="${pkgs.lib.makeLibraryPath [
                                                                                                            pkgs.glib
                                                                                                            pkgs.nspr
                                                                                                            pkgs.nss
                                                                                                            pkgs.nssTools
                                                                                                            pkgs.stdenv.cc.cc.lib
                                                                                                            pkgs.atk
                                                                                                            pkgs.at-spi2-core
                                                                                                            pkgs.dbus
                                                                                                            pkgs.cups
                                                                                                            pkgs.expat
                                                                                                            pkgs.xorg.libxcb
                                                                                                            pkgs.libxkbcommon
                                                                                                            pkgs.alsa-lib
                                                                                                            pkgs.mesa
                                                                                                            pkgs.xorg.libX11
                                                                                                            pkgs.xorg.libXext
                                                                                                            pkgs.cairo
                                                                                                            pkgs.pango
                                                                                                            pkgs.systemd
                                                                                                            pkgs.xorg.libXcomposite
                                                                                                            pkgs.xorg.libXdamage
                                                                                                            pkgs.xorg.libXfixes
                                                                                                            pkgs.xorg.libXrandr
                                                                                                        ]}${ "$" }{LDlibRARY_PATH:+:$LDlibRARY_PATH}"
                                                                                                        SPEC="$( mktemp --suffix ".spec.js" /mounts/temporary/XXXXXXXX )" || failure 6252736109145105
                                                                                                        ./node_modules/.bin/playwright codegen --output="$SPEC"
                                                                                                        echo "${ "$" }{SPEC/#\/mounts\/temporary/\/tmp}"
                                                                                                    '' ;
                                                                                                variables = { } ;
                                                                                            } ;
                                                                                    type = lib.types.package ;
                                                                                } ;
                                                                        demo =
                                                                            lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        chromium = { read-only = true ; source = pkgs.chromium ; type = "bind" ; } ;
                                                                                                        migrate = { read-only = true ; source = config.visa.backend.database.migrate.package ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    { pkgs , ... } :
                                                                                                        [
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        ${ config.visa.backend.database.migrate.environments.staging.down }/bin/down
                                                                                                        ${ config.visa.backend.database.migrate.environments.staging.up }/bin/up
                                                                                                        cd /mounts/package
                                                                                                        BROWSER=chromium HEADLESS=false node demo.js
                                                                                                    '' ;
                                                                                                variables = { } ;
                                                                                            } ;
                                                                                    type = lib.types.package ;
                                                                                } ;
                                                                        demos =
                                                                            lib.mkOption
                                                                                {
                                                                                    type =
                                                                                        let
                                                                                            demos = ./playwright/demos ;
                                                                                            in
                                                                                                pkgs.stdenv.mkDerivation
                                                                                                    {
                                                                                                        installPhase = ''install-phase "$out"'' ;
                                                                                                        name = "demos" ;
                                                                                                        nativeBuildInputs =
                                                                                                            [
                                                                                                                (
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "install-phase" ;
                                                                                                                            runtimeInputs = [ ( config.failure { } ) pkgs.coreutils pkgs.findutils ] ;
                                                                                                                            text =
                                                                                                                                let
                                                                                                                                    script =
                                                                                                                                        config.lazy-shell-application
                                                                                                                                            {
                                                                                                                                                mounts =
                                                                                                                                                    {
                                                                                                                                                        chromium = { read-only = true ; source = pkgs.chromium ; type = "bind" ; } ;
                                                                                                                                                        package = { read-only = true ; source = config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                                                                        playwright = { type = "temporary" ; } ;
                                                                                                                                                    } ;
                                                                                                                                                name = "execute" ;
                                                                                                                                                post = null ;
                                                                                                                                                runtime-inputs =
                                                                                                                                                    { pkgs , ... } :
                                                                                                                                                        [
                                                                                                                                                            config.visa.backend.database.migrate.environments.staging.down
                                                                                                                                                            config.visa.backend.database.migrate.environments.staging.up
                                                                                                                                                            pkgs.chromium
                                                                                                                                                            pkgs.coreutils
                                                                                                                                                            pkgs.findutils
                                                                                                                                                            pkgs.nodejs_20
                                                                                                                                                            pkgs.glib
                                                                                                                                                        ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        cd /mounts/playwright
                                                                                                                                                        cp --recursive "/mounts/package/." .
                                                                                                                                                        export PATH="$PATH:/mounts/package/node_modules/.bin"
                                                                                                                                                        down
                                                                                                                                                        up
                                                                                                                                                        /mounts/playwright/node_modules/.bin/playwright test "$SPEC"
                                                                                                                                                    '' ;
                                                                                                                                                variables = { } ;
                                                                                                                                            } ;
                                                                                                                                    in
                                                                                                                                        ''
                                                                                                                                            OUT="$1"
                                                                                                                                            mkdir --parents "$OUT"
                                                                                                                                            find ${ demos } -name "*.spec.js" | sort | while read -r SPEC
                                                                                                                                            do
                                                                                                                                                RELATIVE_SPEC="${ "$" }{SPEC}"
                                                                                                                                                mkdir --parents "$OUT/$RELATIVE_SPEC"
                                                                                                                                                sed -e "s#\$SPEC#${ demos }/$RELATIVE_SPEC#" -e "$OUT/$RELATIVE_SPEC" ${ script }/bin/execute
                                                                                                                                                chmod a+rwx "$OUT/$RELATIVE_SPEC"
                                                                                                                                            done
                                                                                                                                        '' ;
                                                                                                                        }
                                                                                                                )
                                                                                                            ] ;
                                                                                                        src = ./. ;
                                                                                                    } ;
                                                                                    default = lib.types.package ;
                                                                                } ;
                                                                        execute =
                                                                            lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        chromium = { read-only = true ; source = pkgs.chromium ; type = "bind" ; } ;
                                                                                                        package = { read-only = true ; source = config.visa.playwright.package ; type = "bind" ; } ;
                                                                                                        playwright = { type = "temporary" ; } ;
                                                                                                    } ;
                                                                                                name = "execute" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    { pkgs , ... } :
                                                                                                        [
                                                                                                            config.visa.backend.database.migrate.environments.staging.down
                                                                                                            config.visa.backend.database.migrate.environments.staging.up
                                                                                                            pkgs.chromium
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.findutils
                                                                                                            pkgs.nodejs_20
                                                                                                            pkgs.glib
                                                                                                        ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        cd /mounts/playwright
                                                                                                        cp --recursive "/mounts/package/." .
                                                                                                        export PATH="$PATH:/mounts/package/node_modules/.bin"
                                                                                                        find /mounts/playwright/tests -name "*.spec.js" | sort | while read -r SPEC
                                                                                                        do
                                                                                                            down
                                                                                                            up
                                                                                                            /mounts/playwright/node_modules/.bin/playwright test "$SPEC"
                                                                                                        done
                                                                                                    '' ;
                                                                                                variables = { } ;
                                                                                            } ;
                                                                                    type = lib.types.package ;
                                                                                } ;
                                                                        fetch =
                                                                            lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        config.lazy-shell-application
                                                                                            {
                                                                                                mounts =
                                                                                                    {
                                                                                                        pwd = { source = "." ; type = "bind" ; } ;
                                                                                                    } ;
                                                                                                name = "fetch" ;
                                                                                                post = null ;
                                                                                                runtime-inputs =
                                                                                                    { pkgs , ... } :
                                                                                                        [
                                                                                                            (
                                                                                                                config.tree-serialization.explode
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
                                                                                                variables = { } ;
                                                                                            } ;
                                                                                    type = lib.types.package ;
                                                                                } ;
                                                                        package =
                                                                            lib.mkOption
                                                                                {
                                                                                    default =
                                                                                        let
                                                                                            code = ./. ;
                                                                                            in
                                                                                                pkgs.runCommand
                                                                                                    "package"
                                                                                                    {
                                                                                                        nativeBuildInputs =
                                                                                                            [
                                                                                                                (
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "install-it" ;
                                                                                                                            runtimeInputs = [ ( config.tree-serialization.implode { input = "$OUT/node_modules.exploded" ; name = "implode" ; output = "$OUT/node_modules" ; } ) ] ;
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
                                                                                    type = lib.types.package ;
                                                                                } ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                            } ;
                        in
                            {
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
                                                                    identified =
                                                                        if builtins.typeOf input == "lambda" then input module
                                                                        else if builtins.typeOf input == "null" then module
                                                                        else builtins.throw "8439316073299105" ;
                                                                    in
                                                                        with identified ;
                                                                            {
                                                                                config =
                                                                                    {
                                                                                        environment.systemPackages =
                                                                                            [
                                                                                                (
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "execute-migrate" ;
                                                                                                            runtimeInputs = [ config.visa.backend.database.migrate.environments.staging.up ] ;
                                                                                                            text = "up" ;
                                                                                                        }
                                                                                                )
                                                                                                (
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "execute-playwright" ;
                                                                                                            runtimeInputs = [ config.visa.playwright.execute ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    ${ config.visa.playwright.execute }/bin/execute
                                                                                                                '' ;
                                                                                                        }
                                                                                                )
                                                                                            ] ;
                                                                                        # visa.backend.server.environments.staging.secret = 4384081546961841 ;
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
                                    implementation =
                                        if builtins.typeOf output == "lambda" then output implementation
                                        else if builtins.typeOf output == "null" then implementation
                                        else builtins.throw "3348105439709370" ;
                            } ;
        } ;
}
