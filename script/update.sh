#!/bin/bash -eux

echo "==> Disable automatic update check"
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool FALSE

if [[ "$UPDATE" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then

    echo "==> Running software update"
    updates=$(softwareupdate --install --all --verbose 2>&1)
    echo ${updates}

    if [[ ${updates} == *"No new software available"* ]] || [[ ${updates} == *"No updates are available"* ]]
    	exit 0
    fi

    echo "==> Rebooting the machine"
    reboot
    
    sleep 60
fi