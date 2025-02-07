# Exercise 6: Disk and Storage Management

## Overview
This exercise focuses on checking disk usage, analyzing storage, and finding large files in Linux.

## Commands and Explanations

### 1. Check Disk Space Usage
**Command:**
```bash
df -h
```
**Explanation:**
- `df` → Displays available storage on all mounted filesystems.
- `-h` → Human-readable format (MB, GB, TB instead of bytes).

### 2. Check Disk Usage of a Specific Directory
**Command:**
```bash
du -sh ~/Downloads
```
**Explanation:**
- `du` → Displays disk usage of files and directories.
- `-s` → Shows the total size of a directory.
- `-h` → Human-readable format.
- `~/Downloads` → Directory to check.

### 3. Find the 5 Largest Files in Your Home Directory
**Command:**
```bash
du -ah ~ | sort -rh | head -5
```
**Explanation:**
- `du -ah ~` → Lists all files and directories with their sizes.
- `sort -rh` → Sorts results in descending order by size.
- `head -5` → Displays only the top 5 largest files.

### 4. Check Storage Usage of Mounted Drives
**Command:**
```bash
lsblk
```
**Explanation:**
- `lsblk` → Lists all storage devices, partitions, and their mount points.

### 5. Find and Delete Files Larger Than 1GB
**Command:**
```bash
find ~ -type f -size +1G
```
**Explanation:**
- `find` → Searches for files.
- `~` → Searches in the home directory.
- `-type f` → Looks for files only (ignores directories).
- `-size +1G` → Finds files larger than 1GB.

#### To Delete Large Files Found:
```bash
find ~ -type f -size +1G -delete
```
⚠ **Be careful!** This permanently deletes files without confirmation.

## Summary
| Command | Description |
|---------|------------|
| `df -h` | Displays available disk space in a human-readable format. |
| `du -sh <directory>` | Shows the total size of a directory. |
| `du -ah ~ | sort -rh | head -5` | Finds the top 5 largest files in your home directory. |
| `lsblk` | Lists all storage devices and partitions. |
| `find ~ -type f -size +1G` | Finds files larger than 1GB. |
| `find ~ -type f -size +1G -delete` | Deletes files larger than 1GB (use with caution). |

