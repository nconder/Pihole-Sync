# SSH keys are used for authentication 
#!/bin/bash
set -x  # Enable debug mode

# Source files
SOURCE_CUSTOMLIST="/etc/pihole/custom.list"
SOURCE_CNAME="/etc/dnsmasq.d/05-pihole-custom-cname.conf"

# Destination details
DESTINATION_USER="USERNAME"
DESTINATION_IP="YOUR PRIMARY SOURCE SERVER"
DESTINATION_CUSTOMLIST="/etc/pihole/custom.list"
DESTINATION_CNAME="/etc/dnsmasq.d/05-pihole-custom-cname.conf"

# Temporary files for comparison
TEMP_CUSTOMLIST="/tmp/custom.list.tmp"
TEMP_CNAME="/tmp/05-pihole-custom-cname.conf.tmp"

# Function to sync a file if it has changed
sync_file_if_changed() {
    local source=$1
    local destination=$2
    local temp_file=$3

    echo "Checking file: $source"

    # Fetch the remote file to compare
    scp "${DESTINATION_USER}@${DESTINATION_IP}:${destination}" "$temp_file" 2>/dev/null

    if [ $? -ne 0 ]; then
        echo "Failed to fetch $destination from remote. Assuming it needs syncing."
    else
        # Compare the local and remote files
        if cmp -s "$source" "$temp_file"; then
            echo "No changes detected for $source."
            return
        fi
    fi

    echo "File $source has changed. Syncing..."

    # Use rsync to securely transfer the file
    rsync -avz "$source" "${DESTINATION_USER}@${DESTINATION_IP}:${destination}"

    if [ $? -eq 0 ]; then
        echo "Successfully synced $source to $destination."
    else
        echo "Error syncing $source to $destination."
    fi
}

# Execute sync for both files
sync_file_if_changed "$SOURCE_CUSTOMLIST" "$DESTINATION_CUSTOMLIST" "$TEMP_CUSTOMLIST"
sync_file_if_changed "$SOURCE_CNAME" "$DESTINATION_CNAME" "$TEMP_CNAME"

