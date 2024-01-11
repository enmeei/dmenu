{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          stDrv = pkgs.st.overrideAttrs (oldAttrs: {
            src = ./.;
            buildInputs = with pkgs; with xorg; [
              libXinerama
            ] ++ oldAttrs.buildInputs;
          });

        in
        rec
        {
          overlayAttrs = {
            inherit (config.packages) st;
          };

          packages = {
            st = stDrv;
          };
          packages.default = packages.st;

        };

    };
}

