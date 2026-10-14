{ config, pkgs, ... }:

{
  # User details
  home.username = "david";
  home.homeDirectory = "/home/david";

  # This value determines the Home Manager release that your configuration was
  # compatible with. Do NOT change this value without reading the release notes.
  home.stateVersion = "24.11";

  # User-level packages
  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    htop
  ];

  # Program management examples
  programs.git = {
    enable = true;
    userName = "David Parker";
    userEmail = "davparker@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos-vm1";
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
