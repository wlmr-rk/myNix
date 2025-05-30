# Theme and appearance configuration
{ config, pkgs, ... }:
{
  # Notification daemon
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrains Mono Nerd Font 11";
      background-color = "#1a1b26";
      text-color = "#c0caf5";
      border-color = "#7aa2f7";
      border-radius = "8";
    };
  };

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Dark-B";
    };
  };
}
