# **Basic Linux Commands for Beginners**

## 1. File and Directory Management

### Navigating the Filesystem

```bash
pwd
```

Prints the current working directory, helping you know where you are in the file system.

```bash
ls
```

Lists files and directories in the current location.

```bash
ls -l
```

Provides a detailed view, including file permissions, owner, group, size, and modification time.

```bash
ls -a
```

Displays hidden files (files that start with `.`) along with normal files.

```bash
cd ..
```

Moves up one directory level.

```bash
cd ~
```

Moves directly to the user's home directory.

```bash
cd /absolute/path
```

Navigates to an absolute path.

```bash
cd relative/path
```

Navigates to a directory relative to the current location.

### Creating and Deleting Files/Directories

```bash
touch filename.txt
```

Creates a new empty file with the given name.

```bash
mkdir foldername
```

Creates a new directory inside the current location.

```bash
rm filename.txt
```

Deletes a file permanently.

```bash
rm -r foldername
```

Deletes a directory and all its contents recursively.

```bash
cp source.txt destination.txt
```

Copies a file from one location to another.

```bash
cp -r source_folder destination_folder
```

Copies a directory and its contents to another location.

```bash
mv oldname.txt newname.txt
```

Renames a file.

```bash
mv file.txt /path/to/folder
```

Moves a file to a different directory.

### Viewing File Contents

```bash
cat filename.txt
```

Displays the entire content of a file.

```bash
nano filename.txt
```

Opens a file in the Nano text editor, allowing easy editing.

```bash
less filename.txt
```

Opens a file for viewing, allowing scrolling through large files without loading everything at once.

* Use `/search_term` to find text inside the file.
* Press `q` to exit `less`.

## 2. File Permissions and Ownership

### Viewing and Changing Permissions

```bash
ls -l
```

Displays detailed file permissions.

```bash
chmod 755 filename
```

Changes file permissions:

* `7` (Owner: Read, Write, Execute)
* `5` (Group: Read, Execute)
* `5` (Others: Read, Execute)

```bash
chmod u+x filename
```

Adds execute permission for the file owner.

### Changing Ownership

```bash
sudo chown user:group filename
```

Changes ownership of a file.

```bash
sudo chown -R user:group foldername
```

Changes ownership of a directory and all files within it.

## 3. Process Management

```bash
ps
```

Shows active processes running in the system.

```bash
ps aux
```

Displays all processes with detailed information.

```bash
top
```

Monitors system processes, showing CPU and memory usage in real-time.

```bash
kill PID
```

Terminates a process using its Process ID (PID).

```bash
kill -9 PID
```

Forcefully kills a process if it does not terminate normally.

```bash
htop
```

Provides an interactive process viewer, similar to `top`, but more user-friendly (needs installation).

## 4. Disk and System Information

```bash
df -h
```

Displays available and used disk space in human-readable format.

```bash
du -sh foldername
```

Shows the total size of a folder.

```bash
free -h
```

Displays memory (RAM) usage.

```bash
uname -a
```

Provides detailed system information, including kernel version and architecture.

```bash
uptime
```

Shows system uptime, load average, and how long the system has been running.

## 5. Networking Commands

```bash
curl ifconfig.me
```
Fetches your public IPv4 address using a simple HTTP request.

```bash
curl -6 ifconfig.me
```
Fetches your public IPv6 address using a simple HTTP request.

```bash
ping google.com
```

Checks network connectivity by sending test packets to the specified address.

```bash
curl http://example.com
```

Fetches webpage content and displays it in the terminal.

```bash
ip addr
```

Displays network interface details, including IP addresses and status.

```bash
sudo lsof -i :8080
```

To check which process is using a specific port (e.g., port 8080).

```bash
netstat -tuln
```

Lists active network connections and open ports.

## 6. Archiving and Compression

```bash
tar -cvf archive.tar file1 file2
```

Creates an archive of multiple files.

```bash
tar -xvf archive.tar
```

Extracts an archive.

```bash
gzip file.txt
```

Compresses a file to reduce its size.

```bash
gunzip file.txt.gz
```

Decompresses a `.gz` compressed file.

## 7. Searching for Files and Text

### Finding Files

```bash
find /path -name "filename"
```

Searches for a file by name in a specified location.

```bash
find /path -type f
```

Finds all files in a directory.

```bash
find /path -type d
```

Finds all directories in a location.

### Searching Inside Files

```bash
grep "pattern" filename
```

Searches for a specific text pattern in a file.

```bash
grep -r "pattern" /path/to/folder
```

Searches for text across multiple files in a directory.

## 8. Viewing Large Files Efficiently

```bash
less filename
```

Opens a large file for viewing without loading everything at once.

* Use `/search_term` to find occurrences of a word or phrase.
* Press `q` to exit `less`.

## 9. User and Group Management

### 🔹 User Management

```bash
sudo adduser username
```

Creates a new user with a home directory and prompts for password setup and user info.

```bash
sudo useradd username
```

Adds a new user without creating a home directory by default.

```bash
sudo useradd -m username
```

Adds a user and manually creates a home directory.

```bash
sudo passwd username
```

Sets or changes the password for an existing user.

```bash
sudo deluser username
```

Deletes the specified user from the system.

```bash
cat /etc/passwd
```

Lists all users on the system.

```bash
getent passwd username
```

Displays detailed information about a specific user.

### 🔹 Group Management

```bash
sudo groupadd groupname
```

Creates a new group.

```bash
sudo groupdel groupname
```

Deletes an existing group.

```bash
sudo usermod -aG groupname username
```

Adds an existing user to a specified group without removing them from other groups.

```bash
groups username
```

Displays all groups that a user is a member of.

```bash
id username
```

Shows UID, GID, and all group memberships for a user.

```bash
cat /etc/group
```

Lists all groups on the system.

### 🔹 Viewing Permissions and Ownership

```bash
ls -l
```

Shows detailed file and directory listings, including permissions, owners, and group ownership.

```bash
stat filename
```

Displays detailed status and permissions of a file.

```bash
namei -l /path/to/file
```

Shows permission breakdown of each directory in the path.

```bash
sudo find /home -user username
```

Finds all files owned by a specific user.

```bash
sudo find /home -group groupname
```

Finds all files owned by a specific group.

## Practice Tips

1. Experiment with creating, moving, and deleting files to understand filesystem commands.
2. Regularly check file permissions with `ls -l` before modifying them.
3. Use `ps` and `top` to monitor active processes and manage system resources.
4. Learn to find files efficiently using `find` and `grep`.
5. Use `less` to view log files instead of opening them in a text editor.
6. Always refer to `man command` (e.g., `man ls`) to get detailed explanations of any Linux command.

By understanding and practicing these commands, you'll be able to navigate and manage a Linux system more effectively!
