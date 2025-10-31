{
  description = "Zig development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, zig-overlay }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          # zig-overlay.packages.${system}.master  # Latest nightly build
          zig-overlay.packages.${system}."0.15.2"  # Specific version
          pkgs.gtk4
          pkgs.glib
          pkgs.gobject-introspection
          pkgs.pkg-config
          pkgs.blueprint-compiler
        ];

        shellHook = ''
          export PKG_CONFIG_PATH="${pkgs.gtk4}/lib/pkgconfig:${pkgs.glib}/lib/pkgconfig:$PKG_CONFIG_PATH"
        '';
      };
    };
}
