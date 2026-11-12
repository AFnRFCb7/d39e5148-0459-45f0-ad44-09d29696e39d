{
    inputs =
        {
            failure.url = "git+https://github.com/AFnRFCb7/failure.git?rev=bd884096b699e726966184317713141c9fd36d2b" ;
            lazy-shell-application.url = "git+https://github.com/AFnRFCb7/lazy-shell-application.git?rev=5db812bddfaedaa358cf5fcd16cb992d26615315" ;
            lazy-shell-resource.url = "git+https://github.com/AFnRFCb7/resource.git?rev=dce3521d2b757012a1b6e7a62868c215e73dabf4" ;
            nixpkgs.url = "github:Nixos/nixpkgs/nixos-24.11" ;
            sequential.url = "git+https://github.com/AFnRFCb7/f85ebe91-4135-4df9-9f8e-41b18583abe6.git?rev=134ecb84a68bd6885f396dd32a372ef906700037" ;
            tree-serialization.url = "git+https://github.com/AFnRFCb7/tree-serialization.git?rev=bd827097a40fc71b9cb7fbf68f571678ad1b768b" ;
            trip.url = "git+https://github.com/AFnRFCb7/1f343d60-2ecb-434e-b606-751c4ad2c485.git?rev=7c0925bbc627bb3b8afd21afcb9f38aa702724fd" ;
            visa.url = "git+https://github.com/AFnRFCb7/d39e5148-0459-45f0-ad44-09d29696e39d.git?rev=a40d151bcb1fcb92ad315d279f7d6138b4b66537" ;
            visitor.url = "git+https://github.com/AFnRFCb7/visitor.git?rev=9b9471c3661d02640e60b09cd4873bf664f96be1" ;
            wrap.url = "git+https://github.com/AFnRFCb7/bc122403-1370-4d95-bae6-d9e9e069570a.git?rev=153f9b499a4cb2cf1c972940a8501e7c708f7e43" ;
        } ;
    outputs =
        {
            failure ,
            lazy-shell-application ,
            lazy-shell-resource ,
            nixpkgs ,
            self ,
            sequential ,
            tree-serialization ,
            trip ,
            visa ,
            visitor ,
            wrap
        } :
            let
                system = "x86_64-linux" ;
                pkgs =
                    import nixpkgs
                        {
                            system = system;
                        } ;
                in
                    {
                        nixosConfigurations=
                            {
                                user =
                                    nixpkgs.lib.nixosSystem
                                        {
                                            modules =
                                                [
                                                    ( failure.lib { } ).implementation
                                                    ( lazy-shell-application.lib { } ).implementation
                                                    ( lazy-shell-resource.lib { } ).implementation
                                                    ( sequential.lib { } ).implementation
                                                    ( tree-serialization.lib { } ).implementation
                                                    ( trip.lib { } ).implementation
                                                    ( visa.lib { } ).implementation
                                                    ( visitor.lib { } ).implementation
                                                    ( wrap.lib { } ).implementation
                                                    (
                                                        { config, pkgs, ... } :
                                                            {
                                                                services.openssh =
                                                                    {
                                                                        enable = true;
                                                                        settings.PasswordAuthentication = false ;
                                                                        settings.KbdInteractiveAuthentication = false ;
                                                                    } ;
                                                                users.users.user =
                                                                    {
                                                                        isNormalUser = true ;
                                                                        extraGroups = [ "wheel" ] ;
                                                                        openssh.authorizedKeys.keys =
                                                                            [
                                                                                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFEZrOaD5MaAQn+D5SPoKT4+nhSvckzeViurec+LVnAX"
                                                                            ] ;
                                                                    } ;
                                                                security.sudo.wheelNeedsPassword = false ;
                                                            }
                                                    )
                                                ] ;
                                            system = system ;
                                        } ;
                           } ;
                    } ;
}

