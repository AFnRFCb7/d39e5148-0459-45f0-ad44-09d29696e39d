{
    inputs = {
        failure.url = "github:AFnRFCb7/failure";
        lazy-shell-application.url = "github:AFnRFCb7/lazy-shell-application";
        lazy-shell-resource.url = "github:AFnRFCb7/resource";
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        promoter.url = "github:AFnRFCb7/9f052589-300f-4b3c-bac3-418ffadac16c";
        sequential.url = "github:AFnRFCb7/f85ebe91-4135-4df9-9f8e-41b18583abe6";
        tree-serialization.url = "github:AFnRFCb7/tree-serialization";
        trip.url = "github:AFnRFCb7/1f343d60-2ecb-434e-b606-751c4ad2c485";
        visa.url = "github:AFnRFCb7/d39e5148-0459-45f0-ad44-09d29696e39d";
        visitor.url = "github:AFnRFCb7/visitor";
        wrap.url = "github:AFnRFCb7/bc122403-1370-4d95-bae6-d9e9e069570a";
    };
    outputs =
        {
            failure ,
            lazy-shell-application ,
            lazy-shell-resource ,
            nixpkgs ,
            promoter ,
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
                                                    ( promoter.lib { } ).implementation
                                                    ( sequential.lib { } ).implementation
                                                    ( tree-serialization.lib { } ).implementation
                                                    ( trip.lib { } ).implementation
                                                    ( visa.lib { } ).implementation
                                                    ( visitor.lib { } ).implementation
                                                    ( wrap.lib { } ).implementation
                                                    (
                                                        { config, pkgs, ... } :
                                                            {
                                                                boot.loader.grub.enable = true;
                                                                boot.loader.grub.device = "/dev/xvda";
                                                                environment =
                                                                    {
                                                                        sessionVariables =
                                                                            {
                                                                                PROMOTE = config.promote ;
                                                                            } ;
                                                                    } ;
                                                                fileSystems."/" = {
                                                                  device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
                                                                  fsType = "ext4";
                                                                };
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
                                                                system.stateVersion = "24.11";
                                                                visa.backend.gateway.environments.staging.name = "staging.globalvisa.vip" ;
                                                            }
                                                    )
                                                ] ;
                                            system = system ;
                                        } ;
                           } ;
                    } ;
}

