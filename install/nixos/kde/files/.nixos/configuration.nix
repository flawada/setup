{ config, pkgs, ... }:

{
  imports = [ /etc/nixos/configuration.nix ];

  # packages
  environment.systemPackages = with pkgs; [
    ghostty
    fastfetch
    git
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      niu = "clear && fastfetch && nix flake update --flake ~/.nixos && sudo nixos-rebuild switch --impure --flake ~/.nixos";
      nis = "clear && fastfetch && sudo nixos-rebuild switch --impure --flake ~/.nixos";
      nic = "nano ~/.nixos/configuration.nix";
      nif = "nano ~/.nixos/flake.nix";
      nih = "nano ~/.nixos/home.nix";
    };
  };

  users.defaultUserShell = pkgs.zsh;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.firefox.enable = true;

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.USERNAME = import ./home.nix;
    backupFileExtension = "backup";
  };

  # variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # cleanup
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };  

  nix.optimise = {
    automatic = true;
    dates = "weekly";
  };

  # boot
  boot.loader.systemd-boot.configurationLimit = 3; 

#  boot.loader.systemd-boot.extraEntries."fedora.conf" = ''
#      title Fedora
#      efi /EFI/fedora/shimx64.efi
#    '';

  # kernel
  #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];



