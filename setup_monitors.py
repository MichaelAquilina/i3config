#! /usr/bin/python3
from typing import Dict
import argparse
import os
import json
import sys
import subprocess


def get_setup_key(monitors: Dict[str, str]) -> str:
    return " ".join(sorted(m for m, s in monitors.items() if s["state"] == "connected"))


def get_monitors() -> Dict[str, str]:
    """
    Get all the monitors and their states from xrandr
    """

    result = subprocess.run(["xrandr"], stdout=subprocess.PIPE)
    monitors = {}

    for line in result.stdout.decode("utf8").split("\n"):
        if "connected" in line:
            tokens = line.split(" ")
            name = tokens[0]
            state = tokens[1]
            active = "x" in tokens[2]

            monitors[name] = {
                "state": state,
                "active": active,
            }

    return monitors


def load_configuration() -> Dict:
    try:
        path = os.path.expanduser("~/.xrandr_config.json")
        with open(path, "r") as fp:
            return json.load(fp)
    except FileNotFoundError:
        return {}


def write_configuration(config: Dict) -> None:
    path = os.path.expanduser("~/.xrandr_config.json")
    with open(path, "w") as fp:
        json.dump(config, fp)


def restart_i3() -> None:
    subprocess.run(["i3-msg", "restart"])


def set_xrandr(target: str, config: Dict, monitors: Dict[str, str]) -> None:
    params = ["xrandr", "--nograb"]
    used_monitors = set()

    for entry in config[target]:
        params.extend(["--output", entry["output"]])
        params.extend(entry["params"])

        used_monitors.add(entry["output"])

    for monitor in monitors:
        if monitor not in used_monitors:
            params.extend(["--output", monitor, "--off"])

    print(f"Running {params}", file=sys.stderr)
    subprocess.run(params)
    config["current"] = config[target]


def show_rofi() -> None:
    """
    Shows rofi launcher that allows user to select desired setup for list of connected
    monitors. Will save the configuration to xrandr_config.json for auto-setup when
    connected or disconnected.
    """
    monitors = get_monitors()
    connected = [m for m, s in monitors.items() if s["state"] == "connected"]

    rofi_data = {}

    for monitor in connected:
        rofi_data[f"{monitor}"] = [
            {
                "output": monitor,
                "params": [
                    "--auto",
                ],
            }
        ]

    for m1 in connected:
        for m2 in connected:
            if m1 == m2:
                continue

            rofi_data[f"{m1} -> {m2}"] = [
                {
                    "output": m1,
                    "params": [
                        "--auto",
                        "--left-of", m2,
                    ],
                },
                {
                    "output": m2,
                    "params": [
                        "--auto",
                    ],
                }
            ]

    data = "\n".join(rofi_data.keys()).encode("utf8")

    result = subprocess.run([
        "rofi",
        "-dmenu", "-p",
        "Monitor setup 2", "-a", "0", "-no-custom"], input=data, stdout=subprocess.PIPE)

    selection = result.stdout.decode("utf-8").strip()


    if selection:
        config = load_configuration()

        data = rofi_data[selection]
        target = get_setup_key(monitors)

        config[target] = data
        set_xrandr(target, config, monitors)

        write_configuration(config)
        restart_i3()


def main() -> None:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command")

    rofi_parser = subparsers.add_parser("rofi")
    setup_parser = subparsers.add_parser("setup")
    setup_parser.add_argument("--startup", "-s", action="store_true")

    args = parser.parse_args()

    if args.command == "setup":
        setup(args.startup)
    elif args.command == "rofi":
        show_rofi()


def setup(startup: bool) -> None:
    """
    Attempts to setup monitors using previously selected mechanism for the current state.
    If no previous mechanism was set for the current state - turn on all connected monitors.

    A state is defined as the list of currently connected monitors.
    """
    monitors = get_monitors()
    target = get_setup_key(monitors)

    print(target)

    config = load_configuration()

    if target in config:
        # If current configuration is already the same as the target then dont bother
        # running xrandr. Ignore this check if the startup option is enabled.
        if not startup and config.get(target) == config.get("current"):
            return

        set_xrandr(target, config, monitors)
        write_configuration(config)
        return
    else:
        print("Unable to find matching configuration. Will turn on all connected monitors", file=sys.stderr)
        config[target] = []
        for key, mon in monitors.items():
            config[target].append({
                "output": key,
                "params": [
                    "--auto" if mon["state"] == "connected" else "--off"
                ],
            })

        set_xrandr(target, config, monitors)
        write_configuration(config)


if __name__ == "__main__":
    main()
