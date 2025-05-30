# GUI Applications
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    nautilus
    mpv
    imv
    vlc
    pavucontrol
    fuzzel
    ncspot
  ];

  # Fuzzel launcher configuration
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono Nerd Font:size=12";
        terminal = "alacritty";
        width = 60; # Wider for more content
        horizontal-pad = 16;
        vertical-pad = 8;
        inner-pad = 8;
        layer = "overlay"; # Ensures it appears above everything
        prompt = "実行 "; # Japanese for "execute" with space
        placeholder = "コマンド入力..."; # "Enter command..." in Japanese
        icon-theme = "Papirus-Dark";
        lines = 12; # Show more results
        tabs = 4;
        line-height = 20;
        letter-spacing = 0;
      };

      colors = {
        # Ultra dark background matching your theme
        background = "0a0a0aef";
        text = "c0caf5ff";
        prompt = "bb9af7ff"; # Tokyo Night purple (matches active border)
        placeholder = "565f89ff"; # Muted text color
        input = "c0caf5ff"; # Input text color
        match = "7aa2f7ff"; # Highlighted match text (Tokyo Night blue)
        selection = "bb9af7ff"; # Selection background (purple)
        selection-text = "1a1b26ff"; # Selection text (dark)
        selection-match = "ffffff ff"; # White text for matched parts in selection
        border = "bb9af7ff"; # Border color matching active window border
      };

      border = {
        width = 1;
        radius = 0; # Sharp edges for dystopian feel (matching your rounding = 0)
      };

      dmenu = {
        exit-immediately-if-empty = false;
        print-index = false;
      };

      key-bindings = {
        # Vim-like navigation for sigma productivity
        prev = "Up ctrl+k";
        next = "Down ctrl+j";
        prev-page = "Page_Up ctrl+u";
        next-page = "Page_Down ctrl+d";

        cancel = "Escape ctrl+c ctrl+g";
        execute = "Return KP_Enter";
        execute-or-next = "Tab";

        # Additional productivity bindings
        cursor-left = "Left ctrl+b";
        cursor-right = "Right ctrl+f";
        cursor-home = "Home ctrl+a";
        cursor-end = "End ctrl+e";

        delete-prev = "BackSpace";
        delete-next = "Delete";
      };
    };
  };
}
