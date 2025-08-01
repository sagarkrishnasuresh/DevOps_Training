# Exercise 3: Working with File Content

## Overview
This exercise focuses on creating, viewing, and manipulating text files in Linux.

## Commands and Explanations

### 1. Create a File and Add Content
**Command:**
```bash
nano commands.txt
```
**Explanation:**
- `nano` → Opens a **text editor** inside the terminal.
- `commands.txt` → Name of the file to create/edit.

#### Steps:
1. Type three Linux commands inside the file.
2. Save the file by pressing **CTRL + X**, then **Y**, then **Enter**.

### 2. View the Contents of the File
**Command:**
```bash
cat commands.txt
```
**Explanation:**
- `cat` → Displays the **entire content** of a file.
- `commands.txt` → The file you created.

### 3. Display Only the First Two Lines of the File
**Command:**
```bash
head -n 2 commands.txt
```
**Explanation:**
- `head` → Shows the **first few lines** of a file.
- `-n 2` → Limits output to **only 2 lines**.

### 4. Display Only the Last Line of the File
**Command:**
```bash
tail -n 1 commands.txt
```
**Explanation:**
- `tail` → Displays the **last few lines** of a file.
- `-n 1` → Shows **only the last line**.

## Summary
| Command | Description |
|---------|------------|
| `nano filename` | Opens a file in the nano text editor. |
| `cat filename` | Displays the entire file contents. |
| `head -n X filename` | Shows the first X lines of a file. |
| `tail -n X filename` | Shows the last X lines of a file. |

