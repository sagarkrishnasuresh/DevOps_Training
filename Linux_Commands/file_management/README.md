# Exercise 2: File and Directory Management

## Overview
This exercise focuses on creating, renaming, and moving files and directories in Linux.

## Commands and Explanations

### 1. Create a Directory
**Command:**
```bash
mkdir ~/devops_practice
```
**Explanation:**
- `mkdir` → Creates a new directory.
- `~/` → Represents the **home directory**.
- `devops_practice` → Name of the directory being created.

### 2. Create a File Inside the Directory
**Command:**
```bash
touch ~/devops_practice/testfile.txt
```
**Explanation:**
- `touch` → Creates an **empty file** if it doesn’t already exist.
- `~/devops_practice/testfile.txt` → Full path of the file being created.

### 3. Rename the File
**Command:**
```bash
mv ~/devops_practice/testfile.txt ~/devops_practice/devops_notes.txt
```
**Explanation:**
- `mv` → Moves or renames a file.
- `testfile.txt` → The original filename.
- `devops_notes.txt` → The new filename.

### 4. Move the File to Another Location
**Command:**
```bash
mv ~/devops_practice/devops_notes.txt /tmp/
```
**Explanation:**
- Moves `devops_notes.txt` from `~/devops_practice/` to the `/tmp/` directory.
- `/tmp/` is a temporary directory used for temporary file storage.

## Summary
| Command | Description |
|---------|------------|
| `mkdir ~/devops_practice` | Creates a new directory in the home folder. |
| `touch ~/devops_practice/testfile.txt` | Creates an empty text file. |
| `mv oldname newname` | Renames a file. |
| `mv file /destination/` | Moves a file to another location. |

