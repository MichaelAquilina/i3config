# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
font pango:DejaVu Sans Mono 10

# start dunst notification daemon
exec --no-startup-id dunst -config "~/.config/dunst/dunstrc"

# use Mouse+Mod1 to drag floating windows to their wanted position
floating_modifier Mod1

focus_follows_mouse no

# kill focused window
bindsym Mod1+q kill

# application shortcuts
bindsym Mod1+d exec rofi -show drun
bindsym Mod1+p exec $HOME/bin/rofi-pass
bindsym Mod1+Return exec tilix

# alternatively, you can use the cursor keys:
bindsym Mod1+Left focus left
bindsym Mod1+Down focus down
bindsym Mod1+Up focus up
bindsym Mod1+Right focus right

# alternatively, you can use the cursor keys:
bindsym Mod1+Shift+Left move left
bindsym Mod1+Shift+Down move down
bindsym Mod1+Shift+Up move up
bindsym Mod1+Shift+Right move right

# split in horizontal orientation
bindsym Mod1+h split h

# split in vertical orientation
bindsym Mod1+v split v

# enter fullscreen mode for the focused container
bindsym Mod1+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym Mod1+s layout stacking
bindsym Mod1+w layout tabbed
bindsym Mod1+e layout toggle split

# toggle tiling / floating
bindsym Mod1+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym Mod1+space focus mode_toggle

# focus the parent container
bindsym Mod1+a focus parent

# focus the child container
bindsym Mod1+c focus child

# Define names for default workspaces for which we configure key bindings later on.
# We use variables to avoid repeating the names in multiple places.
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# switch to workspace
bindsym Mod1+1 workspace $ws1
bindsym Mod1+2 workspace $ws2
bindsym Mod1+3 workspace $ws3
bindsym Mod1+4 workspace $ws4
bindsym Mod1+5 workspace $ws5
bindsym Mod1+6 workspace $ws6
bindsym Mod1+7 workspace $ws7
bindsym Mod1+8 workspace $ws8
bindsym Mod1+9 workspace $ws9
bindsym Mod1+0 workspace $ws10

# move focused container to workspace
bindsym Mod1+Shift+1 move container to workspace $ws1
bindsym Mod1+Shift+2 move container to workspace $ws2
bindsym Mod1+Shift+3 move container to workspace $ws3
bindsym Mod1+Shift+4 move container to workspace $ws4
bindsym Mod1+Shift+5 move container to workspace $ws5
bindsym Mod1+Shift+6 move container to workspace $ws6
bindsym Mod1+Shift+7 move container to workspace $ws7
bindsym Mod1+Shift+8 move container to workspace $ws8
bindsym Mod1+Shift+9 move container to workspace $ws9
bindsym Mod1+Shift+0 move container to workspace $ws10

# reload the configuration file
bindsym Mod1+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym Mod1+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym Mod1+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape or Mod1+r332/usr/share/applications/virtualbox.desktop
        bindsym Return mode "default"
        bindsym Escape mode "default"
        bindsym Mod1+r mode "default"
}

bindsym Mod1+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
        status_command i3blocks
        position top
}

# Set background image
exec feh --bg-scale "/home/michael/Documents/Bloodborne Weapons.png"

default_border pixel 3

# Lock screen
bindsym Mod1+l exec i3lock

assign [class="Slack"] 2

# Bind keys for volume control
bindsym Mod1+F3 exec --no-startup-id pactl set-sink-volume 0 +10% && pkill -SIGRTMIN+10 i3blocks
bindsym Mod1+F2 exec --no-startup-id pactl set-sink-volume 0 -10% && pkill -SIGRTMIN+10 i3blocks
bindsym Mod1+F1 exec --no-startup-id pactl set-sink-mute 0 toggle && pkill -SIGRTMIN+10 i3blocks

# Bind keys for media controls
bindsym Mod1+F5 exec playerctl play-pause
bindsym Mod1+F6 exec playerctl previous
bindsym Mod1+F7 exec playerctl next