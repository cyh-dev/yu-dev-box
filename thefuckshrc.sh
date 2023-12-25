
#!/bin/bash

if type thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
else
  echo "thefuck is not installed. please install it."
fi
