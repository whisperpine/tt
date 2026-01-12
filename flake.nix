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
          rust.nightly."2026-01-12".default.override {
            extensions = [ "rust-src" ];
            targets = [ ];
          };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          # the default dev environment
          default = pkgs.mkShellNoCC {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              # --- others --- #
              just # just a command runner
              typos # check typo issues
              husky # manage git hooks
              git-cliff # generate changelog
              cocogitto # conventional commit toolkit

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

            # The shell script executed when the environment is activated.
            shellHook = /* sh */ ''
              # Print the last modified date of "flake.lock".
              git log -1 --format="%cd" --date=format:"%Y-%m-%d" -- flake.lock |
                awk '{printf "\"flake.lock\" last modified on: %s", $1}' &&
                echo " ($((($(date +%s) - $(git log -1 --format="%ct" -- flake.lock)) / 86400)) days ago)"
              # Install git hooks managed by husky.
              if [ ! -e "./.husky/_" ]; then
                husky install
              fi
            '';
          };

          # This dev environment is used in CI.
          # "nix develop .#gen"
          gen = pkgs.mkShellNoCC {
            # The Nix packages installed in the dev environment.
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
