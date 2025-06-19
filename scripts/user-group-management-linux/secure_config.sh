#!/bin/bash

set -e

echo "⚙️ Cleaning and resetting user group configurations..."

# Define users
ADMINS=("vikas" "sagar" "vinu")
DEVELOPERS=("thej" "animesh" "sanskriti" "raushan" "srihari" "sanjay")

# Preserve group names
PRESERVE_GROUPS=("admin" "developers")

# Step 1: Create preserved groups if not present
for grp in "${PRESERVE_GROUPS[@]}"; do
    getent group "$grp" || sudo groupadd "$grp"
done

# Step 2: Clean group membership for each user
reset_user_groups() {
    local user="$1"
    local primary_group
    primary_group=$(id -gn "$user")

    echo "🔄 Resetting groups for $user (preserving primary group: $primary_group)..."

    # Remove all secondary groups
    sudo usermod -G "" "$user"

    # Re-add necessary group
    if [[ " ${ADMINS[*]} " =~ " $user " ]]; then
        sudo usermod -aG admin "$user"
    elif [[ " ${DEVELOPERS[*]} " =~ " $user " ]]; then
        sudo usermod -aG developers "$user"
    fi
}

for user in "${ADMINS[@]}" "${DEVELOPERS[@]}"; do
    reset_user_groups "$user"
done

# Step 3: Delete unnecessary groups (skip system/reserved ones)
CLEANUP_GROUPS=$(cut -d: -f1 /etc/group | grep -Ev '^root|^adm|^cdrom|^sudo|^dip|^plugdev|^lxd|^netdev|^audio|^video|^staff|^users|^nogroup|^systemd|^input|^lp|^sys|^tty|^messagebus|^shadow|^mail|^daemon|^scanner|^wheel|^disk|^ubuntu|^docker|^admin|^developers$')

for grp in $CLEANUP_GROUPS; do
    echo "🗑️ Removing unused group: $grp"
    sudo groupdel "$grp" || echo "⚠️ Could not delete group $grp (maybe in use)"
done

echo "✅ Cleanup complete. Now showing final group memberships:"
for user in "${ADMINS[@]}" "${DEVELOPERS[@]}"; do
    echo "User: $user"
    id "$user"
    echo "----------------------------------"
done
