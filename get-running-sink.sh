#! /bin/bash
pactl list short sinks | grep RUNNING | cut -d$'\t' -f1
