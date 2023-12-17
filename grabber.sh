#!/bin/bash

# Define the root folder, number of days, and number of seconds
root_folder="/home/majid/Pictures/Coder_Screenshots/"
days=30
seconds=10
notification_interval=30
notification_text="Dr. Coder's Screenshot Grabber is working"

# Display a notification to the user
notify-send "Dr. Coder's Screenshot Grabber" "is starting"

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

    # Take a screenshot of the current window
    /usr/bin/spectacle -a -b -n -o "$root_folder/$date/$timestamp.png"

    # Scale down the screenshot to 50%
    convert "$root_folder/$date/$timestamp.png" -resize 50% "$root_folder/$date/$timestamp.png"

    # Increment the grab counter
    ((grab_counter++))

    # Check if it's time to display a notification
    if (( grab_counter % notification_interval == 0 )); then
        notify-send "Dr. Coder's Screenshot Grabber" "$notification_text"
    fi

    # Wait for 10 seconds before taking the next screenshot
    sleep 10

    # Calculate the cutoff time
    cutoff_time=$(($(date +%s) - days * 24 * 60 * 60 - seconds))

    # Find the folders older than the cutoff time and delete them
    find "$root_folder" -type d -mtime +"$days" -exec rm -rf {} \;
done
