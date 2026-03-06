#!/bin/bash

echo "Checking for updates..."

# Checks which system is running (Fedora or Arch) and executes the correct manager.

if [ -f /etc/fedora-release ]; then
    notify-send -u normal "Update started" "The system update was started now."
    sudo dnf upgrade --refresh -y
elif [ -f /etc/arch-release ]; then
    notify-send -u normal "Update started" "The system update was started now."
    sudo pacman -Syu --noconfirm
else
    echo "System not recognised. Cancelling operation."
    exit 1
fi

# Check that the update has completed without errors.
if [ $? -eq 0 ]; then
    # Send notification to Hyprland (critical priority to draw attention)
    notify-send -u critical "Update complete" "The system will restart in 30 seconds. Press Ctrl+C on the terminal."

    echo -e "\n========================================="
    echo "       Update complete!"
    echo "========================================="
    echo "Press Ctrl+C at any time to cancel."
    echo ""

    # Countdown loop
    for i in {30..1}; do
        echo -ne "Restarting the system in: $i seconds...\r"
        sleep 1
    done

    echo -e "\nReboot now!"
    reboot
else
    # Notification if something goes wrong or you cancel the update midway

    notify-send -u normal "Update failed." "An error occurred or the process was interrupted. The restart was cancelled."
    
    echo -e "\n[ERROR] The update failed or was interrupted."
    echo "The automatic restart has been cancelled for security reasons."
    
    # 15-second pause so you can read the error before the terminal window closes on its own
    sleep 15
fi
