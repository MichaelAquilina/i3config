connected="$(xrandr | grep -w connected | cut -d" " -f1)"

if [[ "$connected" == "eDP-1" ]]; then
    xrandr --dpi 188
else
    xrandr --dpi 96
fi
