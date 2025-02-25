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

### 4. Basic System Information
**Command:**
```bash
uname -a
```
**Explanation:**
- Displays kernel version and system architecture.

### 5. CPU Information
**Command:**
```bash
lscpu
```
**Explanation:**
- Shows processor details, including cores, threads, and architecture.

### 6. Memory (RAM) Information
**Command:**
```bash
free -h
```
**Explanation:**
- Displays total, used, and available RAM.

### 7. Storage Information
**Command:**
```bash
df -h
```
**Explanation:**
- Displays disk space usage for all mounted drives.

### 8. GPU Information
**Command:**
```bash
lspci | grep VGA
```
**Explanation:**
- Lists the graphics card(s) installed in the system.

### 9. Operating System Information
**Command:**
```bash
cat /etc/os-release
```
**Explanation:**
- Shows the name and version of your Linux distribution.

### 10. Network Information
**Command:**
```bash
ip a
```
**Explanation:**
- Displays IP addresses and network interfaces.

## Summary
| Command | Description |
|---------|-------------|
| `pwd` | Prints the current directory. |
| `ls -la ~` | Lists all files (including hidden ones) in the home directory. |
| `cat /etc/hostname` | Displays the system's hostname. |
| `hostname` | Alternative command to check hostname. |
| `uname -a` | Basic system info (kernel and architecture). |
| `lscpu` | CPU information. |
| `free -h` | Memory (RAM) usage. |
| `df -h` | Disk space usage. |
| `lspci | grep VGA` | GPU information. |
| `cat /etc/os-release` | Operating system information. |
| `ip a` | Network information. |

This concludes the basic system information commands in Linux.

