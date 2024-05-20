{ config, pkgs, ... }:

let
  isNixOSSystem = true;
in
{
  nixpkgs.config.allowUnfree = true;
  targets.genericLinux.enable = !isNixOSSystem;
  programs.home-manager.enable = true;
  home = {
    stateVersion = "23.11";
    username = "ricog";
    homeDirectory = "/home/ricog";
    packages = with pkgs; [
      # NOTE: Terminal
      kitty tmux
      # NOTE: Big programs
      chromium steam discord
      # NOTE: Essential programs
      git ripgrep p7zip wget
      # NOTE: Editors
      neovim
      # NOTE: Formatters
      stylua cmake-format
      # NOTE: LSPs
      lua-language-server cmake-language-server
      # NOTE: Display/Window manager
      xorg.xrandr autorandr i3 i3status
      # NOTE: Fonts
      (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    ];
    file = {
      # ".mydotfile".text = ''
      #   ...
      # '';
      # ".myotherdotfile".source = some/path;
    };
    sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Rico Groth";
      userEmail = "groth.rico@protonmail.com";
    };
    neovim = {
      # WARNING: don't set "enable = true",
      # this will create 2 nvim binaries in the nix store and cause a clash
      defaultEditor = true;
    };
    kitty = {
      enable = true;
      font.size = 11;
      font.name = "JetBrainsMono Nerd Font";
    };
  };
}
