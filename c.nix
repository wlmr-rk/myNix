# Edit this file in ~/wlmrNix/c.nix
# Run 'sudo nixos-rebuild switch' after changes
{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "splash" ];
  services.fstrim.enable = true;

  # Network
  networking.hostName = "wlmrNixOS";
  networking.networkmanager.enable = true;

  # Set Timezone
  time.timeZone = "Asia/Manila";

  # Users
  users.users.wlmr = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  services.displayManager.cosmic-greeter.enable = true;

  # Enable programs needed for Wayland/Hyprland
  programs.hyprland.enable = true;
  programs.fish.enable = true;

  # XDG Portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # System packages (minimal - most stuff in Home Manager)
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    neovim
  ];

  # Disable Xorg completely since we're using pure Wayland
  services.xserver.enable = false;

  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb"; # Keep xcb as a fallback for apps not fully Wayland-native
    SDL_VIDEODRIVER = "wayland";
    GDK_BACKEND = "wayland,x11"; # Keep x11 as a fallback
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "22";
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.wlmr = import ./h.nix;
    backupFileExtension = "bak";
  };

  system.stateVersion = "25.11";
}

