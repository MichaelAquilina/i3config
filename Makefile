install:
	mkdir -p $$HOME/.config/i3
	mkdir -p $$HOME/.config/i3blocks
	mkdir -p $$HOME/.config/polybar
	mkdir -p $$HOME/dunst/
	mkdir -p $$HOME/rofi/
	ln -sf $$PWD/i3 $$HOME/.config/i3/config
	ln -sf $$PWD/i3blocks $$HOME/.config/i3blocks/config
	ln -sf $$PWD/dunstrc $$HOME/.config/dunst/dunstrc
	ln -sf $$PWD/compton.conf $$HOME/.config/compton.conf
	ln -sf $$PWD/rofi $$HOME/.config/rofi/config
	ln -sf $$PWD/lock_screen.sh $$HOME/bin/lock_screen.sh
	ln -sf $$PWD/setup_monitors.py $$HOME/bin/setup_monitors.py
	ln -sf $$PWD/set_dpi.sh $$HOME/bin/set_dpi.sh
	ln -sf $$PWD/zypper_check.sh $$HOME/bin/zypper_check.sh
	ln -sf $$PWD/get-running-sink.sh $$HOME/bin/get-running-sink.sh
	ln -sf $$PWD/polybar $$HOME/.config/polybar/config
