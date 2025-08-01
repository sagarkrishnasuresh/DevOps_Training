# 🛡️ Ubuntu System Activity & Audit Guide

This document provides a collection of useful commands to monitor, audit, and analyze user activities on an Ubuntu machine. Each section includes command usage along with important flags and a brief description. All commands are ready to copy and use.

---

## 1. 👤 Logged-In Users & Session Info

### 🔹 Who is currently logged in:

```bash
who -u
```

* **Description**: Shows users currently logged in with session and idle time.

### 🔹 Detailed session activity:

```bash
w
```

* **Description**: Displays users currently logged in and what they are doing.
* **Flag**: `-h` to hide the header (optional).

### 🔹 Last login for all users:

```bash
lastlog | head -20
```

* **Description**: Shows the last login of all users.

---

## 2. 🕓 Login History (Past Sessions)

### 🔹 Full login/logout history:

```bash
last -n 50
```

* **Flag**: `-n [number]` – Number of entries to display.

### 🔹 Login history in the last 24 hours:

```bash
last -s "-24hours"
```

* **Flag**: `-s [time]` – Start time.

### 🔹 Failed login attempts (requires sudo):

```bash
sudo lastb -n 20
```

---

## 3. ❌ Failed Login Attempts

### 🔹 From auth log using grep:

```bash
sudo grep -Ei "failed|invalid|authentication failure" /var/log/auth.log | tail -20
```

### 🔹 Using journalctl:

```bash
sudo journalctl --since="24 hours ago" | grep -Ei "failed|invalid|authentication failure"
```

* **Flags**:

  * `--since="time"`: Start time window.
  * `--until="time"`: End time window.

### 🔹 SSH login failures:

```bash
sudo grep "Failed password" /var/log/auth.log | tail -10
```

---

## 4. 🔑 Sudo Command Usage

### 🔹 From auth log:

```bash
sudo grep "sudo.*COMMAND" /var/log/auth.log | tail -20
```

### 🔹 From journalctl:

```bash
sudo journalctl --since="24 hours ago" | grep -i "sudo.*COMMAND"
```

---

## 5. 📜 Bash History with Timestamps

### 🔹 Enable timestamp in bash history:

```bash
export HISTTIMEFORMAT="%F %T "
```

### 🔹 View your recent commands:

```bash
tail -50 ~/.bash_history
```

### 🔹 View another user's history (requires sudo):

```bash
sudo tail -20 /home/username/.bash_history
```

### 🔹 Root user history:

```bash
sudo tail -20 /root/.bash_history
```

---

## 6. 📈 System Metrics

### 🔹 System uptime and load:

```bash
uptime
```

### 🔹 CPU/memory snapshot:

```bash
vmstat 1 1
```

### 🔹 Load average (alternative):

```bash
cat /proc/loadavg
```

### 🔹 Disk usage of root partition:

```bash
df -h /
```

---

## 7. 🔍 User Activity Monitoring (Advanced)

### 🔹 Install acct (if not available):

```bash
sudo apt install acct
```

### 🔹 Command execution logs:

```bash
lastcomm
```

### 🔹 Total login time per user:

```bash
ac -p
```

### 🔹 Search audit logs (requires auditd):

```bash
sudo ausearch --start today --event EXECVE
```

---

## 8. 🔄 Real-Time Monitoring

### 🔹 Live view of logged-in users:

```bash
watch who
```

### 🔹 Live disk usage:

```bash
watch 'df -h /'
```

---

## 📝 Notes

* Root access is required for some logs and user histories.
* Replace `/var/log/auth.log` with `/var/log/secure` on CentOS/RHEL.
* Use `man [command]` to explore more options.

---

> ✅ This document can serve as a handy reference for system administrators, DevOps engineers, or anyone managing an Ubuntu server.
