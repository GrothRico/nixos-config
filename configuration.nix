{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

   nixpkgs.config.allowUnfree = true;
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
   time.timeZone = "Europe/Berlin";
 
   boot.loader = {
    # FIXME: use grub instead (device should be set properly)
    # grub = {
    #   enable = true;
    #   device = "/dev/sda";
    #   useOSProber = true;
    # };
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
   };
 
   networking = {
     networkmanager.enable = true;
     hostName = "nixos";
     wireless.enable = false; # Disables wireless support via wpa_supplicant.
     # proxy = {
     #   default = "";
     #   noProxy = "";
     # };
   };
 
 
   i18n = {
     defaultLocale = "en_US.UTF-8";
     extraLocaleSettings = {
       LC_ADDRESS = "de_DE.UTF-8";
       LC_IDENTIFICATION = "de_DE.UTF-8";
       LC_MEASUREMENT = "de_DE.UTF-8";
       LC_MONETARY = "de_DE.UTF-8";
       LC_NAME = "de_DE.UTF-8";
       LC_NUMERIC = "de_DE.UTF-8";
       LC_PAPER = "de_DE.UTF-8";
       LC_TELEPHONE = "de_DE.UTF-8";
       LC_TIME = "de_DE.UTF-8";
     };
   };
 
   services = {
     printing.enable = true;
     xserver = {
       enable = true;
       layout = "us";
       xkbVariant = "";
       windowManager = {
         i3.enable = true;
       };
       displayManager = {
         gdm.enable = true;
         autoLogin = {
           enable = true;
 	  user = "ricog";
         };
	# FIXME: should be possible without specifying the actual screen
 	sessionCommands = ''
 	  xrandr --output Virtual1 --mode 1920x1080
 	'';
       };
       desktopManager = {
 	xterm.enable = false;
       };
       excludePackages = with pkgs; [
         xterm
       ];
     };
   };
 
   environment = {
     sessionVariables = {
       TERMINAL = [ "kitty" ];
     };
   };
 
   # Enable sound with pipewire.
   sound.enable = true;
   hardware.pulseaudio.enable = false;
   security.rtkit.enable = true;
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };
 
   # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.ricog = {
     isNormalUser = true;
     description = "Rico Groth";
     extraGroups = [ "networkmanager" "wheel" ];
     packages = with pkgs; [
       chromium
       steam
       discord
       lua-language-server
       clang-tools
       clang
       stylua
       cmake-language-server
       cmake-format
     ];
   };
 
   systemd.services = {
     # Workaround for GNOME autologin
     # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
     "getty@tty1".enable = false;
     "autovt@tty1".enable = false;
   };
   
 
   environment.systemPackages = with pkgs; [
     xorg.xrandr
     autorandr
     neovim
     nodejs_21
     wget
     kitty
     tmux
     tree
     python312
     i3
     i3status
     git
     home-manager
     gcc
     gnumake
     cmake
     nasm
     gdb
     ripgrep
     htop
     zip
     unzip
     p7zip
   ];
 
   fonts.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];
 
   programs = {
     neovim = {
       enable = true;
       defaultEditor = true;
     };
     # TODO: set user name and email using home-manager
     git = {
       enable = true;
       lfs.enable = true;
     };
   };
 
   system.stateVersion = "23.11";
}
