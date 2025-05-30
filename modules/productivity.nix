# Productivity and learning applications
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    obsidian
    anki-bin
    # System monitoring
    btop
  ];
}
