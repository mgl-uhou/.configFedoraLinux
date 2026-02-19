#!/bin/bash
hyprpicker -f hex | sed 's/^#\(.*\)/rgba(\1ff)/' | wl-copy
