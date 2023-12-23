#!/bin/bash

# Define the root folder, number of days, and number of seconds
root_folder="/home/majid/Pictures/Coder_Screenshots/"
days=30
seconds=10
notification_interval=30
app_name="Dr. Coder's Screenshot Grabber"
notification_text="is working"
scale="50%"

mkdir -p "$root_folder"

# Display a notification to the user
notify-send "$app_name" "is starting"

# Initialize the grab counter
grab_counter=0

while true
do
    # Get the current date
    date=$(date +%Y-%m-%d)

    # Create a new directory for today's screenshots if it doesn't exist
    mkdir -p "$root_folder/$date"

    # Get the current timestamp
    timestamp=$(date +%Y-%m-%d_%H-%M-%S)

    # Check if another instance of Spectacle is running
    if pgrep -x spectacle > /dev/null; then
        echo "Another instance of Spectacle is running. Skipping this grab."
    else
        if qdbus org.kde.screensaver /ScreenSaver org.freedesktop.ScreenSaver.GetActive | grep -q true; then
            echo "Screen is locked. Skipping this grab."
        else
            # Take a screenshot of the current window
            /usr/bin/spectacle -a -b -n -o "$root_folder/$date/$hour/$timestamp.png"
            # Scale down the screenshot to 50%
            convert "$root_folder/$date/$hour/$timestamp.png" -resize $scale "$root_folder/$date/$hour/$timestamp.jpg"
            rm "$root_folder/$date/$hour/$timestamp.png"
        fi
    fi
    
    # Increment the grab counter
    ((grab_counter++))

    # Check if it's time to display a notification
    if (( grab_counter % notification_interval == 0 )); then
        notify-send "$app_name" "$notification_text"
    fi

    # Wait for 10 seconds before taking the next screenshot
    sleep 10

    # Calculate the cutoff time
    cutoff_time=$(($(date +%s) - days * 24 * 60 * 60 - seconds))

    # Find the folders older than the cutoff time and delete them
    find "$root_folder" -type d -mtime +"$days" -exec rm -rf {} \;
done
