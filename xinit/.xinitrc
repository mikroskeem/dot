# NVIDIA
#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --output 'eDP-1-1' --set 'PRIME Synchronization' '1'
#xrandr --output eDP-1 --scale 1.2x1.2 --panning 1920x1080
xrandr --dpi 106
xrandr --auto

# X resources
xrdb -l ~/.Xresources

# Redshift
redshift &

# WM
exec i3
