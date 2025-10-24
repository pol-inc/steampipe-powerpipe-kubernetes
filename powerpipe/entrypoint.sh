#!/bin/bash

echo "Running entrypoint.sh script..."


if [ -n "$INSTALL_MODS" ]; then
    echo "INSTALL_MODS variable is defined: $INSTALL_MODS"
    for mod in $INSTALL_MODS; do
        echo "Installing Mod: $mod"
        ./powerpipe mod install "$mod" > /dev/null
    done
fi

echo "Updating Mods..."
./powerpipe mod update > /dev/null

if [ -n "$POWERPIPE_DATABASE" ]; then
    if grep -q '^  database = ' mod.pp; then
        sed -i.bak "s|^  database = .*|  database = \"$POWERPIPE_DATABASE\"|" mod.pp
    else
        sed -i.bak "/^  require {/i \\  database = \"$POWERPIPE_DATABASE\"" mod.pp
    fi
fi

echo "Mod List:"
./powerpipe mod list

echo "Starting Powerpipe:"
./powerpipe server
