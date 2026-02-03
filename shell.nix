{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    glfw
    # mesa
    # man
    # man-pages
  ];
}
