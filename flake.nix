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
                                                            FETCH_NODE_SERVER = config.visa.backend.server.fetch ;
                                                        } ;
                                                    systemd =
                                                        {
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
                                                                            server =
                                                                                {
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
                                                                                } ;
                                                                        } ;
                                                                    frontend =
                                                                        {
                                                                            admin = null ;
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

