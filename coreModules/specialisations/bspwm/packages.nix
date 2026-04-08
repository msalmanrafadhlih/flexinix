{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ======== BSPWM Stuff
    polybarFull
    sxhkd
    picom
    rofi
    eww
    i3lock-color
  
    # ======== TOOLS
    sound-theme-freedesktop
    libcanberra-gtk3
    mpv-unwrapped
    brightnessctl
    flameshot
    imagemagick
    clipmenu
    pamixer
    xclip # Clipboard
    dunst
	  kdocker
		qview
    maim
    feh
    bc

    # ======== UTILS
    imlib2
    xinit
    psmisc
    xsetroot
    xrandr
    xinput
    xdotool
    xcolor
    xev # key(board) mapping
  ];
}
