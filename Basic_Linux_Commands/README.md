# **Basic Linux Commands for Beginners**

### 1. File and Directory Management

#### **Navigating the Filesystem**
- `pwd` - Prints the current working directory, helping you know where you are in the file system.
- `ls` - Lists files and directories in the current location.
  - `ls -l` - Provides a detailed view, including file permissions, owner, group, size, and modification time.
  - `ls -a` - Displays hidden files (files that start with `.`) along with normal files.
- `cd` - Changes directory to a specified path.
  - `cd ..` - Moves up one directory level.
  - `cd ~` - Moves directly to the user's home directory.
  - `cd /absolute/path` - Navigates to an absolute path.
  - `cd relative/path` - Navigates to a directory relative to the current location.

#### **Creating and Deleting Files/Directories**
- `touch filename.txt` - Creates a new empty file with the given name.
- `mkdir foldername` - Creates a new directory inside the current location.
- `rm filename.txt` - Deletes a file permanently.
  - `rm -r foldername` - Deletes a directory and all its contents recursively.
- `cp source.txt destination.txt` - Copies a file from one location to another.
  - `cp -r source_folder destination_folder` - Copies a directory and its contents to another location.
- `mv oldname.txt newname.txt` - Renames a file.
  - `mv file.txt /path/to/folder` - Moves a file to a different directory.

#### **Viewing File Contents**
- `cat filename.txt` - Displays the entire content of a file.
- `nano filename.txt` - Opens a file in the Nano text editor, allowing easy editing.
- `less filename.txt` - Opens a file for viewing, allowing scrolling through large files without loading everything at once.
  - Use `/search_term` to find text inside the file.
  - Press `q` to exit `less`.

---

### 2. File Permissions and Ownership

#### **Viewing and Changing Permissions**
- `ls -l` - Displays detailed file permissions.
- `chmod 755 filename` - Changes file permissions:
  - `7` (Owner: Read, Write, Execute)
  - `5` (Group: Read, Execute)
  - `5` (Others: Read, Execute)
- `chmod u+x filename` - Adds execute permission for the file owner.

#### **Changing Ownership**
- `sudo chown user:group filename` - Changes ownership of a file.
- `sudo chown -R user:group foldername` - Changes ownership of a directory and all files within it.

---

### 3. Process Management

- `ps` - Shows active processes running in the system.
  - `ps aux` - Displays all processes with detailed information.
- `top` - Monitors system processes, showing CPU and memory usage in real-time.
- `kill PID` - Terminates a process using its Process ID (PID).
  - `kill -9 PID` - Forcefully kills a process if it does not terminate normally.
- `htop` - Provides an interactive process viewer, similar to `top`, but more user-friendly (needs installation).

---

### 4. Disk and System Information

- `df -h` - Displays available and used disk space in human-readable format.
- `du -sh foldername` - Shows the total size of a folder.
- `free -h` - Displays memory (RAM) usage.
- `uname -a` - Provides detailed system information, including kernel version and architecture.
- `uptime` - Shows system uptime, load average, and how long the system has been running.

---

### 5. Networking Commands

- `ping google.com` - Checks network connectivity by sending test packets to the specified address.
- `curl http://example.com` - Fetches webpage content and displays it in the terminal.
- `ip addr` - Displays network interface details, including IP addresses and status.
- `netstat -tuln` - Lists active network connections and open ports.

---

### 6. Archiving and Compression

- `tar -cvf archive.tar file1 file2` - Creates an archive of multiple files.
- `tar -xvf archive.tar` - Extracts an archive.
- `gzip file.txt` - Compresses a file to reduce its size.
  - `gunzip file.txt.gz` - Decompresses a `.gz` compressed file.

---

### 7. Searching for Files and Text

#### **Finding Files**
- `find /path -name "filename"` - Searches for a file by name in a specified location.
- `find /path -type f` - Finds all files in a directory.
- `find /path -type d` - Finds all directories in a location.

#### **Searching Inside Files**
- `grep "pattern" filename` - Searches for a specific text pattern in a file.
- `grep -r "pattern" /path/to/folder` - Searches for text across multiple files in a directory.

---

### 8. Viewing Large Files Efficiently

- `less filename` - Opens a large file for viewing without loading everything at once.
  - Use `/search_term` to find occurrences of a word or phrase.
  - Press `q` to exit `less`.

---

### Practice Tips
1. Experiment with creating, moving, and deleting files to understand filesystem commands.
2. Regularly check file permissions with `ls -l` before modifying them.
3. Use `ps` and `top` to monitor active processes and manage system resources.
4. Learn to find files efficiently using `find` and `grep`.
5. Use `less` to view log files instead of opening them in a text editor.
6. Always refer to `man command` (e.g., `man ls`) to get detailed explanations of any Linux command.

By understanding and practicing these commands, you'll be able to navigate and manage a Linux system more effectively!

