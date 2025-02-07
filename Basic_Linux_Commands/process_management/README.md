# Exercise 5: Process Management

## Overview
This exercise focuses on monitoring running processes, finding process IDs (PIDs), and terminating processes in Linux.

## Commands and Explanations

### 1. Check Running Processes
**Command:**
```bash
ps aux
```
**Explanation:**
- `ps` → Stands for **Process Status**; displays a list of running processes.
- `a` → Shows processes for **all users**, not just the current user.
- `u` → Shows **user ownership** and CPU/memory usage.
- `x` → Includes **processes not attached to a terminal**.

### 2. Find a Specific Process
**Command:**
```bash
ps aux | grep process_name
```
**Explanation:**
- `| grep process_name` → Filters the list to show only **processes matching "process_name"**.

### 3. Monitor Processes in Real-Time
**Command:**
```bash
top
```
**Explanation:**
- `top` → Shows **real-time** system resource usage, including CPU/memory usage.
- **Press `q`** to exit.

#### Alternative Command:
```bash
htop
```
- A more **user-friendly** version of `top` (install with `sudo apt install htop`).

### 4. Kill a Process by PID
**Command:**
```bash
kill <PID>
```
**Explanation:**
- `kill` → Sends a signal to **terminate** a process.
- `<PID>` → Replace with the actual Process ID.

#### If the process does not stop, force kill it:
```bash
kill -9 <PID>
```
- `-9` sends a **SIGKILL** signal, **forcefully terminating** the process.

### 5. Kill a Process by Name
**Command:**
```bash
pkill -f process_name
```
**Explanation:**
- `pkill` → Kills a process by **name instead of PID**.
- `-f` → Searches for the full process name.

### 6. Check System Uptime
**Command:**
```bash
uptime
```
**Explanation:**
- Displays **how long the system has been running**, along with the number of logged-in users and load average.

## Summary
| Command | Description |
|---------|------------|
| `ps aux` | Shows all running processes. |
| `ps aux | grep process_name` | Finds a specific process. |
| `top` | Monitors processes in real time. |
| `htop` | A user-friendly version of `top`. |
| `kill <PID>` | Terminates a process by ID. |
| `kill -9 <PID>` | Forcefully kills a process. |
| `pkill -f process_name` | Kills a process by name. |
| `uptime` | Displays system uptime and load average. |

