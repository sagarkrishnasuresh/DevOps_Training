# User and Group Management Script

## Overview

This script (`secure_config.sh`) is designed to standardize user group memberships on a Linux system and remove unnecessary groups to improve security and simplify user management.

It is ideal for setups where users are categorized into roles such as **admins** and **developers**, and where a shared system account (e.g., `shareduser`) is used across multiple individuals.

---

## Purpose

* Assign users to clearly defined roles: `admin` or `developers`
* Remove all other secondary group memberships from users
* Delete non-essential, unused groups
* Preserve the group configuration for a shared user account (`shareduser`)

---

## User Roles

| User         | Role      | Groups Assigned                 |
| ------------ | --------- | ------------------------------- |
| `admin1`     | Admin     | `admin1`, `admin`               |
| `admin2`     | Admin     | `admin2`, `admin`               |
| `dev1`       | Developer | `dev1`, `developers`            |
| `dev2`       | Developer | `dev2`, `developers`            |
| `dev3`       | Developer | `dev3`, `developers`            |
| `dev4`       | Developer | `dev4`, `developers`            |
| `shareduser` | Shared    | All existing groups (unchanged) |

---

## Actions Performed by the Script

1. Ensures `admin` and `developers` groups exist.
2. Resets group memberships for users:

    * Admins get only the `admin` group.
    * Developers get only the `developers` group.
3. Deletes all non-essential groups, excluding preserved/system groups.
4. Prints final group memberships for verification.

---

## Usage

1. Save the script as `clean_user_groups.sh`
2. Make it executable:

   ```bash
   chmod +x secure_config.sh
   ```
3. Run the script with root privileges:

   ```bash
   sudo ./secure_config.sh
   ```

---

## Notes

* Must be run with `sudo` or as `root`.
* Assumes all listed users already exist on the system.
* Preserves system-reserved groups like `sudo`, `docker`, `netdev`, etc.
* The shared user (`shareduser`) is excluded from modification.
* You can customize user lists and preserved groups within the script.

---

## License

This script is provided for internal system administration and infrastructure setup. Use at your own risk and modify as needed for your specific environment.
