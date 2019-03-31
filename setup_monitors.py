#! /usr/bin/python3
from typing import Dict
import os
import sys
import subprocess


def get_monitors() -> Dict[str, str]:
    """
    Get all the monitors and their states from xrandr
    """

    result = subprocess.run(["xrandr"], stdout=subprocess.PIPE)
    monitors = {}

    for line in result.stdout.decode("utf8").split("\n"):
        if "connected" in line:
            name = line.split(" ")[0]
            state = line.split(" ")[1]
            monitors[name] = state

    return monitors


def main():
    """
    Attempts to setup monitors using previously selected mechanism for the current state.
    If no previous mechanism was set for the current state - turn on all connected monitors.

    A state is defined as the list of currently connected monitors.
    """

    monitors = get_monitors()
    target = " ".join(sorted(m for m, s in monitors.items() if s == "connected"))
    print(target, file=sys.stderr)

    path = os.path.expanduser("~/.xrandr_config")

    try:
        with open(path, "r") as fp:
            data = fp.read()

        for line in data.split("\n"):
            if not line:
                continue

            tokens = line.split(":")
            key = tokens[0]
            command = tokens[1]

            print(f"Matching with {key}", file=sys.stderr)
            if key == target:
                print(f"Match Found. Running '{command}'", file=sys.stderr)
                subprocess.run(command.split(" "))
                return

    except FileNotFoundError:
        print(f"No existing {path}", file=sys.stderr)

    print("Unable to find matching configuration. Will turn on all connected monitors", file=sys.stderr)

    params = ["xrandr"]
    for key, state in monitors.items():
        params.extend(["--output", key])
        params.append("--auto" if state == "connected" else "--off")

    print(f"Running {params}", file=sys.stderr)
    subprocess.run(params)

    print(target)


if __name__ == "__main__":
    main()
