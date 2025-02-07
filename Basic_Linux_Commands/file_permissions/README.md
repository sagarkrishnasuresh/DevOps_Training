# Exercise 4: File Permissions

## Overview
This exercise focuses on checking and modifying file permissions in Linux.

## Commands and Explanations

### 1. Check File Permissions
**Command:**
```bash
ls -l filename
```
**Explanation:**
- `ls -l` → Lists files **with details**, including permissions.
- `filename` → Replace with the actual filename to check its permissions.

#### Example Output:
```
-rw-r--r-- 1 user user 1024 Feb 3 12:00 filename.txt
```
- `-rw-r--r--` → This is the **permission string**.
    - `rwx` → Read (`r`), Write (`w`), Execute (`x`).
    - The **first set** is for the **owner**.
    - The **second set** is for the **group**.
    - The **third set** is for **others**.

### 2. Grant Execute Permission to the Owner
**Command:**
```bash
chmod u+x filename
```
**Explanation:**
- `chmod` → **Change file permissions**.
- `u+x` → Adds **execute (`x`) permission** to the **user (owner)**.
- `filename` → The file to modify.

### 3. Remove Read and Write Permissions for Others
**Command:**
```bash
chmod o-rw filename
```
**Explanation:**
- `o-rw` → Removes **read (`r`) and write (`w`) permissions** for **others (`o`)**.

### 4. Set Specific Permissions Using Numbers
**Command:**
```bash
chmod 755 filename
```
**Explanation:**
| Number | Owner (`u`) | Group (`g`) | Others (`o`) |
|--------|------------|-------------|--------------|
| **7**  | rwx | - | - |
| **5**  | r-x | r-x | r-x |

- `755` means:
    - Owner: **Read, Write, Execute** (`rwx` → `7`).
    - Group: **Read, Execute** (`r-x` → `5`).
    - Others: **Read, Execute** (`r-x` → `5`).

## Summary
| Command | Description |
|---------|------------|
| `ls -l filename` | Displays file permissions. |
| `chmod u+x filename` | Gives **execute** permission to the owner. |
| `chmod o-rw filename` | Removes **read/write** permissions for others. |
| `chmod 755 filename` | Sets permission using **numeric mode**. |

