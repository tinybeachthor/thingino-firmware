{
  description = "Example flake environment for build buildroot projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {
      imports = [
        # Optional: use external flake logic, e.g.
        # inputs.foo.flakeModules.default
      ];
      flake = {
        # Put your original flake attributes here.
      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        # ...
      ];
      perSystem = { config, pkgs, ... }: {
        # Recommended: move all package definitions here.
        # e.g. (assuming you have a nixpkgs input)
        # packages.foo = pkgs.callPackage ./foo/package.nix { };
        # packages.bar = pkgs.callPackage ./bar/package.nix {
        #   foo = config.packages.foo;
        # };
        devShells.default = (pkgs.buildFHSEnv {
          name = "buildroot";
          targetPkgs = pkgs: (with pkgs;
            [
              (lib.hiPrio gcc)
              file
              gnumake
              ncurses.dev
              pkg-config
              unzip
              wget
              pkgsCross.aarch64-multiplatform.gccStdenv.cc
	      glibc.dev
	      libxcrypt

              bc
              bison
              cpio
              cmake
              curl
              file
              flex
              nano
              rsync
              unzip
              ubootTools
              vim
              gawk
              dialog
              newt
            ] ++ pkgs.linux.nativeBuildInputs);
	  profile = ''
	    export CMAKE_POLICY_VERSION_MINIMUM=3.5
	  '';
        }).env;
      };
    });
}
