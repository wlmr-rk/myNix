# Main Home Manager configuration
# This imports all your modular configurations
{ config, pkgs, ... }:
{
  home.username = "wlmr";
  home.homeDirectory = "/home/wlmr";

  # Import all your modular configurations with absolute paths
  imports = [
    /home/wlmr/wlmrNix/modules/hyprland.nix
    /home/wlmr/wlmrNix/modules/terminal.nix
    /home/wlmr/wlmrNix/modules/apps.nix
    /home/wlmr/wlmrNix/modules/theme.nix
    /home/wlmr/wlmrNix/modules/development.nix
    /home/wlmr/wlmrNix/modules/productivity.nix
  ];

  # Basic packages that don't need special config
  home.packages = with pkgs; [
    btop
    fastfetch
    tree
    unzip
    p7zip
    curl
    inotify-tools
    wget
  ];

  programs.git = {
    enable = true;
    userName = "wlmr-rk";
    userEmail = "wlmr.rk@gmail.com";
  };
  home.stateVersion = "25.05";
}
