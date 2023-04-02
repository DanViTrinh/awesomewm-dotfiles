#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# rebindings
xbindkeys &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# polkit for balena etcher
#https://bbs.archlinux.org/viewtopic.php?id=264245
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# getting correct displays
# set in xorg.conf.d later see xrandr man pages for multihead
xrandr --output DP-2 --mode 2560x1440 --rate 164.83 --primary --output DP-0 --right-of DP-2

# unclutter to hide mouse after 5 seconds
unclutter &

exec awesome

