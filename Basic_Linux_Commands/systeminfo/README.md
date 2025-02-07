# Exercise 1: Check System Information

## Overview
This exercise focuses on checking basic system information using Linux commands.

## Commands and Explanations

### 1. Find the Current Working Directory
**Command:**
```bash
pwd
```
**Explanation:**
- `pwd` stands for **Print Working Directory**.
- It displays the **absolute path** of the current directory.

### 2. List All Files (Including Hidden Files) in the Home Directory
**Command:**
```bash
ls -la ~
```
**Explanation:**
- `ls` → Lists files and directories.
- `-l` → Displays details like permissions, owner, size, and modified time.
- `-a` → Shows **hidden files** (files starting with `.`).
- `~` → Represents the **home directory**.

### 3. Check the System's Hostname
**Command:**
```bash
cat /etc/hostname
```
**Explanation:**
- `cat` → Displays the contents of a file.
- `/etc/hostname` → Stores the system’s hostname.

**Alternative Command:**
```bash
hostname
```
- This also prints the system hostname.

## Summary
| Command | Description |
|---------|------------|
| `pwd` | Prints the current directory. |
| `ls -la ~` | Lists all files (including hidden ones) in the home directory. |
| `cat /etc/hostname` | Displays the system's hostname. |
| `hostname` | Alternative command to check hostname. |

