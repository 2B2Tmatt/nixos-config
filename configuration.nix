# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable Flakes and the modern Nix CLI natively
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/New_York";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Graphical Architecture & Display Server
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # GNOME / GDM Base Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Core Display Architecture Frameworks
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Hardware / Printing Subsystems
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user account
  users.users."matt" = {
    isNormalUser = true;
    description = "Matt Ge";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
  virtualisation.docker.enable = true;

  # Global Package Engine Settings
  nixpkgs.config.allowUnfree = true;

  # Dynamic linker helper for pre-compiled non-Nix binaries (Go/Rust/C packages)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];

  # Typography System
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Pure Modern Flake CLI Aliases
  environment.shellAliases = {
    rebuild = "git -C /etc/nixos add -A && sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    rebuild-test = "git -C /etc/nixos add -A && sudo nixos-rebuild test --flake /etc/nixos#nixos";
  };

  # Core System + User Tool Catalog (Combined List)
  environment.systemPackages = with pkgs; [
    # Baseline Utilities
    wget unzip zip curl git fastfetch vim
    fzf zoxide ripgrep fd tree eza btop jq yq-go
    wl-clipboard xclip

    # Core Editors / IDEs
    zed-editor vscode jetbrains.idea-oss

    # C / Systems Infrastructure Development
    gnumake gdb valgrind clang clang-tools

    # Backend Engineering Languages / Environments
    go
    temurin-bin-25
    maven
    nodejs_24 typescript pnpm

    # Desktop Application Environment Ecosystem
    kitty waybar rofi swaynotificationcenter nwg-look hyprpaper
    dbeaver-bin stow
  ];

  system.stateVersion = "26.05";
}
