# Development tools and environments
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust development
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
    cargo-edit
    cargo-watch

    # C, Zig development
    clang
    zig

    # Web development
    nodejs
    typescript

    # Python
    python3
    python3Packages.pip
    python3Packages.ipython
    python3Packages.flake8

    #Nix
    nixpkgs-fmt

    # Version control
    git

    # Editor
    neovim
    tldr
  ];
}
