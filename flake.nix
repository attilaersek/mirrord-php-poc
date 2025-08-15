{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [

      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          rustPlatform = pkgs.makeRustPlatform {
            cargo = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
            rustc = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
          };
          # frida-gum = pkgs.stdenv.mkDerivation {
          #   pname = "frida-gum-unwrapped";
          #   version = srcs.version;
          #   src = pkgs.fetchFromGitHub srcs.frida-gum;

          #   # Rebase of https://github.com/frida/frida-gum/pull/711
          #   patches = [
          #     ./0001-use-libdwarf-0.0-libdwarf-20210528.patch
          #     ./0002-use-libdwarf-0.1.patch
          #     ./0003-use-libdwarf-0.2.patch
          #     ./0004-use-libdwarf-0.3.patch
          #     ./0005-use-libdwarf-0.4-or-later.patch
          #   ];

          #   buildInputs = with pkgs; [
          #     glib-static
          #     pcre2-static
          #     capstone
          #     lzma
          #     libunwind
          #     libelf
          #     libdwarf
          #   ];

          #   nativeBuildInputs = with pkgs; [
          #     meson
          #     pkg-config
          #     ninja
          #   ];
          # };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.rust-overlay.overlays.default
            ];
          };

          packages = {
            # mirrord = rustPlatform.buildRustPackage {
            #   pname = "mirrord";
            #   version = "0.1.0";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "meowjesty";
            #     repo = "mirrord";
            #     rev = "meowchinist/mbe-1322-possibly-missing-fs-hook-for-rename";
            #     sha256 = "sha256-TETraej3QRIyCKWoJS9OXB2Aq6OilF3h/MBpqDGQ5jQ=";
            #   };
            #   PROTOC = "${pkgs.protobuf}/bin/protoc";
            #   cargoHash = "sha256-eM5ClHJQZ8xYxvS/rJ+zW1Qq5l0s/qorsm2+KJk6ztE=";
            #   nativeBuildInputs = [ pkgs.pkg-config ];
            #   env = pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
            #     NIX_LDFLAGS = "-L ${frida-gum}";
            #   };
            #   preConfigure = ''
            #     export BINDGEN_EXTRA_CLANG_ARGS="$BINDGEN_EXTRA_CLANG_ARGS -isystem ${frida-gum}"
            #   '';
            #   buildInputs = [
            #     pkgs.openssl
            #   ]
            #   ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            #     frida-gum
            #     rustPlatform.bindgenHook
            #     pkgs.pkg-config
            #   ];
            # };
          };
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil
              nixfmt-rfc-style
              mirrord
              kind
              kubectl
              php
            ];
          };
          formatter = pkgs.nixfmt-rfc-style;
        };
      flake = {
      };
    };
}
