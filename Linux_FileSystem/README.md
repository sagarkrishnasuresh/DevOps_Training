# Linux File System - Basic Knowledge

## 1. Introduction
The Linux file system is a hierarchical structure that organizes files and directories. It follows the Filesystem Hierarchy Standard (FHS) and provides a standard layout for system files, user data, and application resources.

## 2. File System Structure
The Linux file system starts from the root (`/`) directory and branches into various subdirectories. Some of the key directories include:

- `/`  - Root directory (contains all other directories)
- `/bin` - Essential binary executables
- `/boot` - Bootloader files
- `/dev` - Device files (e.g., hard drives, USB devices)
- `/etc` - Configuration files
- `/home` - Home directories for users
- `/lib` - Shared library files
- `/media` - Mount points for removable media (USB, CD-ROMs)
- `/mnt` - Temporarily mounted file systems
- `/opt` - Optional software packages
- `/proc` - Virtual filesystem for system information
- `/root` - Home directory of the root user
- `/sbin` - System binaries (for system administration)
- `/srv` - Data for services like FTP and HTTP
- `/tmp` - Temporary files
- `/usr` - User binaries, documentation, libraries
- `/var` - Variable files (e.g., logs, cache, mail)

## 3. File Permissions
Each file and directory in Linux has a set of permissions assigned to three categories:
- **Owner** (u) - The creator of the file
- **Group** (g) - Users belonging to a specific group
- **Others** (o) - All other users

Permissions are represented as:
- **r** - Read (4)
- **w** - Write (2)
- **x** - Execute (1)

Example:
```
-rwxr-xr--  1 user group 1234 Jan 01 12:00 file.txt
```
- Owner: `rwx` (read, write, execute)
- Group: `r-x` (read, execute)
- Others: `r--` (read-only)

### Changing Permissions:
- `chmod 755 file.txt` - Sets read, write, execute for owner and read-execute for others

## 4. Common Linux File System Commands
- `ls` - List files and directories
- `cd` - Change directory
- `pwd` - Print current directory
- `mkdir` - Create a new directory
- `rmdir` - Remove an empty directory
- `rm` - Remove files and directories
- `cp` - Copy files and directories
- `mv` - Move or rename files
- `touch` - Create an empty file
- `find` - Search for files
- `locate` - Quickly find files
- `du` - Show disk usage
- `df` - Show disk space usage

## 5. Conclusion
Understanding the Linux file system is essential for managing files, permissions, and storage efficiently. Mastering these basics will help in system administration, security, and troubleshooting.

---
This document provides fundamental knowledge of the Linux file system. More advanced topics, such as file system types, file system mounting, and user & group creation and ownership management, will be covered in future topics.


