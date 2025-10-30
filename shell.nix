{pkg ? import <nixpkgs> {}}:
pkg.mkShell {
 packages = with pkg;[
 zig
 gtk4
 ];
}
