#!/bin/sh

# Check if user provided an arg.
if [ "$#" -ne 1 ]; then
  echo "Please enter the desired brightness (0-7812): "
  read input_level
  sudo tee /sys/class/backlight/intel_backlight/brightness <<< $input_level
else
  sudo tee /sys/class/backlight/intel_backlight/brightness <<< $1
fi

