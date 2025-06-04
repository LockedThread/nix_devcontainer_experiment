{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = with pkgs; [
    # Add your development tools here, e.g.:
    # hello
    nixpkgs-fmt
    rnix-lsp
    nixos-vscode-server

    # for building docker images
    docker-client
    gnumake
    git

  ];
} 