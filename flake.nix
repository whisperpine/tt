{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                rust-overlay.overlays.default
                self.overlays.default
              ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: {
        rustToolchain =
          let
            rust = prev.rust-bin;
          in
          # rust.stable.latest.default.override {
          #   extensions = [ "rust-src" ];
          #   targets = [ ];
          # };
          rust.nightly."2025-06-20".default.override {
            extensions = [ "rust-src" ];
            targets = [ ];
          };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          # the default dev environment
          default = pkgs.mkShell {
            packages = with pkgs; [
              # --- others --- #
              just # just a command runner
              typos # check typo issues
              husky # manage git hooks
              git-cliff # generate changelog

              # --- rust --- #
              rustToolchain
              cargo-edit # managing cargo dependencies
              cargo-deny # linting dependencies
              bacon # background code checker

              # --- openapi --- #
              openapi-generator-cli # generate code based on OAS
              redocly # lint openapi and generate docs

              # --- postgres --- #
              postgresql_17 # for `psql` command
              sqlfluff # sql linter and formatter
              pgcli # an alternative to psql
            ];

            shellHook = ''
              # install git hook managed by husky
              if [ ! -e "./.husky/_" ]; then
                husky install
              fi
              # list containers backed by docker compose
              docker compose ps --all
            '';
          };

          # This dev environment is used in CI.
          # nix develop .#gen
          gen = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              openapi-generator-cli # generate code based on OAS
              redocly # lint openapi and generate docs
            ];
          };
        }
      );
    };
}
