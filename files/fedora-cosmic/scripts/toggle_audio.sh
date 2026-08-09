#!/bin/bash
# Meant to be put under '/usr/bin'

# Define unique name snippets for your devices based on wpctl status output
# Adjust these names if your Input/Output device names differ in 'wpctl status'
# *_NAME1 Gets default priority if the currently active device is unrecognized
SINK_NAME1="TU106 High Definition Audio Controller Digital Stereo"
SINK_NAME2="CORSAIR HS80"

SOURCE_NAME1="fifine Microphone Mono"
SOURCE_NAME2="CORSAIR HS80 RGB Wireless Gaming Receiver Pro"

show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

Toggle audio default sinks or sources using wpctl.

Options:
  -i, --input   Toggle between input sources (microphones)
  -o, --output  Toggle between output sinks (speakers/headphones)
  -h, --help    Display this help message and exit

Note: Options -i, -o, and -h are mutually exclusive and exactly one is required.
EOF
}

# Helper function to trigger desktop pop-ups
send_popup() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}" # Default to normal urgency if not provided

    if command -v notify-send >/dev/null 2>&1; then
        notify-send --urgency="$urgency" --app-name="Audio Switcher" "$title" "$message"
    else
        echo "[$title] $message" >&2
    fi
}

# Parse options using getopt
PARSED=$(getopt --options ioh --longoptions input,output,help --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    show_help
    exit 1
fi

eval set -- "$PARSED"

MODE=""
FLAG_COUNT=0

while true; do
    case "$1" in
        -i|--input)
            MODE="input"
            FLAG_COUNT=$((FLAG_COUNT + 1))
            shift
            ;;
        -o|--output)
            MODE="output"
            FLAG_COUNT=$((FLAG_COUNT + 1))
            shift
            ;;
        -h|--help)
            MODE="help"
            FLAG_COUNT=$((FLAG_COUNT + 1))
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            send_popup "Audio Switcher Error" "Invalid mode '$MODE' encountered." "critical"
            show_help
            exit 1
            ;;
    esac
done

# Ensure exactly one flag was provided
if [ "$FLAG_COUNT" -ne 1 ]; then
    send_popup "Audio Switcher Error" "Wrong amount of flags was provided, Expected one" "critical"
    show_help
    exit 1
fi

# Handle Help flag
if [ "$MODE" = "help" ]; then
    show_help
    exit 0
fi

# --- Execution Logic ---

if [ "$MODE" = "output" ]; then
    # Isolate Sinks block (Audio -> Sinks to Sources)
    BLOCK=$(wpctl status | sed -n '/^Audio/,/^Video/p' | sed -n '/\bSinks:/,/\bSources:/p')
    NAME1="$SINK_NAME1"
    NAME2="$SINK_NAME2"

elif [ "$MODE" = "input" ]; then
    # Isolate Sources block (Audio -> Sources to Filters/Streams)
    BLOCK=$(wpctl status | sed -n '/^Audio/,/^Video/p' | sed -n '/\bSources:/,/\bFilters:/p')
    NAME1="$SOURCE_NAME1"
    NAME2="$SOURCE_NAME2"

else
    send_popup "Audio Switcher Error" "Invalid mode '$MODE' encountered." "critical"
    exit 1
fi

# Dynamically resolve real-time IDs
DEV1=$(echo "$BLOCK" | grep "$NAME1" | grep -oE '[0-9]+' | head -n 1)
DEV2=$(echo "$BLOCK" | grep "$NAME2" | grep -oE '[0-9]+' | head -n 1)

# Grab ID of currently active device (marked by '*')
CURRENT=$(echo "$BLOCK" | grep '*' | grep -oE '[0-9]+' | head -n 1)

# Fail-safe check
if [ -z "$DEV1" ] || [ -z "$DEV2" ] || [ -z "$CURRENT" ]; then
    send_popup "Audio Switcher Error" "Failed to map $MODE devices or detect active $MODE." "critical"
    exit 1
fi

# Toggle logic
if [ "$CURRENT" -ne "$DEV1" ]; then
    wpctl set-default "$DEV1" || send_popup "Audio Switcher" "Failed to switch $MODE device, detected: $DEV1, $DEV2" "critical"
    send_popup "$MODE Switched" "Active $MODE: $NAME1" "low"
else
    wpctl set-default "$DEV2" || send_popup "Audio Switcher" "Failed to switch $MODE device, detected: $DEV1, $DEV2" "critical"
    send_popup "$MODE Switched" "Active $MODE: $NAME2" "low"
fi
