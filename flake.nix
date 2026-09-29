{
    inputs = { } ;
    outputs = { self } :
	    {
	        lib =
	            {
	                failure ,
	                lazy-shell-application
                } :
                    let
                        implementation =
                            { config , lib , pkgs , ... } :
                                let
                                    implementation-parameters =
                                        {
                                            config = config ;
                                            lib = lib ;
                                            pkgs = pkgs ;
                                        } ;
                                    in
                                        {
                                            config =
                                                {
                                                    environment.systemPackages =
                                                        [
                                                            config.visa.backend.server.fetch
                                                        ] ;
                                                    environment.variables =
                                                        {
                                                            VISA_FETCH_NODE_SERVER = config.visa.backend.server.fetch ;
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
                                                                lib.mkIf
                                                                    ( config.visa.backend.enable && config.visa.backend.server.enable )
                                                                    {
                                                                        after = [ "network.target" ] ;
                                                                        name = "${ config.visa.backend.server.name }.service" ;
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
                                                                                                    package = config.visa.backend.server.package ;
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
                                                                                    enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                    name =
                                                                                        lib.mkOption
                                                                                            {
                                                                                                default = "visa-database" ;
                                                                                                type = lib.types.str ;
                                                                                            } ;
                                                                                } ;
                                                                            enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                            gateway =
                                                                                {
                                                                                    enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                    name =
                                                                                        lib.mkOption
                                                                                            {
                                                                                                default = "visa-gateway" ;
                                                                                                type = lib.types.str ;
                                                                                            } ;
                                                                                } ;
                                                                            server =
                                                                                {
                                                                                    enable = lib.mkOption { default = true ; type = lib.types.bool ; } ;
                                                                                    fetch =
                                                                                        lib.mkOption
                                                                                            {
                                                                                                default =
                                                                                                    config.node-package.fetch
                                                                                                        {
                                                                                                            dependencies = { express = "^5.1.0" ; } ;
                                                                                                            scripts = { start = "node server.js 19577" ; } ;
                                                                                                        } ;
                                                                                                type = lib.types.package ;
                                                                                            } ;
                                                                                    name =
                                                                                        lib.mkOption
                                                                                            {
                                                                                                default = "visa-server" ;
                                                                                                type = lib.types.str ;
                                                                                            } ;
                                                                                    package =
                                                                                        lib.mkOption
                                                                                            {
                                                                                                default =
                                                                                                    config.node-package.build ./backend/server ;
                                                                                                type = lib.types.package ;
                                                                                            } ;
                                                                                } ;
                                                                        } ;
                                                                    frontend =
                                                                        {
                                                                            admin = null ;
                                                                            android = null ;
                                                                            web = null ;
                                                                        } ;
                                                                } ;
                                                        } ;
                                                } ;
                                        root-parameters =
                                            {
                                                lazy-shell-application = lazy-shell-application ;
                                            } ;
                                        in
                                            {
                                                check =
                                                    lazy-shell-application :
                                                    {
                                                        client ,
                                                        coreutils ,
                                                        findutils ,
                                                        nixosTest ,
                                                        nodes ,
                                                        order ,
                                                        test-setup ,
                                                        writeShellApplication
                                                    } :
                                                        let
                                                            check-parameters =
                                                                {
                                                                    client = client ;
                                                                    coreutils = coreutils ;
                                                                    findutils = findutils ;
                                                                    lazy-shell-application = lazy-shell-application ;
                                                                    nixosTest = nixosTest ;
                                                                    nodes = nodes ;
                                                                    order = order ;
                                                                    test-setup = test-setup ;
                                                                    writeShellApplication = writeShellApplication ;
                                                                } ;
                                                            in
                                                                check-parameters.lazy-shell-application
                                                                    {
                                                                        client = check-parameters.client ;
                                                                        coreutils = check-parameters.coreutils ;
                                                                        findutils = check-parameters.findutils ;
                                                                        nixosTest = check-parameters.nixosTest ;
                                                                        nodes = check-parameters.nodes ;
                                                                        order = check-parameters.order ;
                                                                        test-setup =
                                                                            builtins.concatLists
                                                                                [
                                                                                    check-parameters.test-setup
                                                                                        [
                                                                                            ''${ check-parameters.client }.wait_for_unit("sally-server.service")''
                                                                                            ''${ check-parameters.client }.wait_for_open_port(10652)''
                                                                                        ]
                                                                                ] ;
                                                                        writeShellApplication = check-parameters.writeShellApplication ;
                                                                    }
                                                                    {
                                                                        mounts = { } ;
                                                                        name = "sally" ;
                                                                        runtime-inputs = pkgs : [ pkgs.coreutils pkgs.curl ] ;
                                                                        text =
                                                                            ''
                                                                                curl --silent --fail http://127.0.0.1:10652/hello?name=4646461779242742 2> /dev/null
                                                                                echo
                                                                                curl --silent --fail --request POST http://127.0.0.1:10652/login 2> /dev/null
                                                                                test -s "$SALLY/apk/debug/app-debug.apk"
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        arguments = [ ] ;
                                                                        standard-error = "" ;
                                                                        standard-input = null ;
                                                                        standard-output =
                                                                            ''
                                                                                hi 4646461779242742
                                                                                login'' ;
                                                                        status = 0 ;
                                                                    } ;
                                                implementation = implementation ;
                                            } ;
        } ;
}

