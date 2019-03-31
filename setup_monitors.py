#! /usr/bin/python3

import os
import subprocess


def get_monitors():
    result = subprocess.run(["xrandr"], stdout=subprocess.PIPE)
    monitors = {}

    for line in result.stdout.decode("utf8").split("\n"):
        if "connected" in line:
            name = line.split(" ")[0]
            state = line.split(" ")[1]
            monitors[name] = state

    return monitors


def main():
    monitors = get_monitors()
    target = " ".join(sorted(m for m, s in monitors.items() if s == "connected"))
    print(target)

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

            print(f"Matching with {key}")
            if key == target:
                print(f"Match Found. Running '{command}'")
                subprocess.run(command.split(" "))
                return

    except FileNotFoundError:
        print(f"No existing {path}")

    print("Unable to find matching configuration. Will turn on all connected monitors")

    params = ["xrandr"]
    for key, state in monitors.items():
        params.extend(["--output", key])
        params.append("--auto" if state == "connected" else "--off")

    print(f"Running {params}")
    subprocess.run(params)


if __name__ == "__main__":
    main()
