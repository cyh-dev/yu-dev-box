
#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
    emulator="$HOME/Library/Android/sdk/emulator/emulator"
    if [ -e "$emulator" ]; then
        cmd="'$emulator -avd Pixel_XL_API_31 -netdelay none -netspeed full'"
        alias android='bash -c "nohup bash -c $cmd 1>/dev/null 2>&1 &"'
    fi
fi
