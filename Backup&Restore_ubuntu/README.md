# Backup and Restore Data in Ubuntu

## **Table of Contents**
- [Introduction](#introduction)
- [Backup Data Using tar](#backup-data-using-tar)
    - [Step 1: Create a Backup](#step-1-create-a-backup)
    - [Step 2: Verify the Backup](#step-2-verify-the-backup)
- [Restore Backup](#restore-backup)
    - [Step 1: Transfer the Backup to the New System](#step-1-transfer-the-backup-to-the-new-system)
    - [Step 2: Extract the Backup](#step-2-extract-the-backup)
    - [Step 3: Verify Restored Data](#step-3-verify-restored-data)
    - [Step 4: Fix Ownership and Permissions](#step-4-fix-ownership-and-permissions)
- [Additional Tips](#additional-tips)

---

## **Introduction**
This guide explains how to **backup and restore user data** in Ubuntu using the `tar` command. The process covers creating a compressed archive of your important files, verifying the backup, and restoring it on another system.

---

## **Backup Data Using tar**
This method creates a compressed tar archive of your **home directory**, including **Desktop, Documents, Downloads, Pictures, and hidden configuration files**.

### **Step 1: Create a Backup**
Run the following command to create a compressed backup file (`tar.gz`):

```bash
tar --exclude='/home/$USER/.cache' \
    --exclude='/home/$USER/.local/share/Trash/*' \
    --exclude='/home/$USER/.mozilla/firefox/*.default-release/cache2' \
    --exclude='/home/$USER/.thumbnails' \
    --exclude='/home/$USER/.npm' \
    --exclude='/home/$USER/.gradle' \
    --exclude='/home/$USER/my_backup.tar.gz' \
    -cvpzf /home/$USER/my_backup.tar.gz /home/$USER/
```

**Explanation:**
- `--exclude` → Prevents unnecessary cache files from being backed up.
- `-c` → Creates an archive.
- `-v` → Displays progress.
- `-p` → Preserves file permissions.
- `-z` → Compresses using gzip.
- `-f` → Specifies the output file.
- `/home/$USER/` → Backs up everything in the home directory.

### **Step 2: Verify the Backup**
To check the contents of the backup **without extracting**:

```bash
tar -tvf /home/$USER/my_backup.tar.gz
```

To check the **size** of the backup file:
```bash
ls -lh /home/$USER/my_backup.tar.gz
```

To check for **specific files**:
```bash
tar -tvf /home/$USER/my_backup.tar.gz | grep "Documents"
```

---

## **Restore Backup**
This section explains how to restore the backup onto a **new Ubuntu machine**.

### **Step 1: Transfer the Backup to the New System**
If the backup is stored on an **external drive**, plug it in and copy the backup file:

```bash
cp /mnt/my_backup.tar.gz /home/$USER/
```

If using **SSH/SCP**, transfer from another system:
```bash
scp user@old_machine:/home/user/my_backup.tar.gz /home/$USER/
```

### **Step 2: Extract the Backup**
Extract the backup file into your home directory:
```bash
tar -xvpzf /home/$USER/my_backup.tar.gz -C /home/$USER/
```

### **Step 3: Verify Restored Data**
After extraction, check if all files are restored:
```bash
ls -lah /home/$USER/
```
To check for hidden files:
```bash
ls -lah /home/$USER/.* | grep -v "not found"
```

### **Step 4: Fix Ownership and Permissions**
If the files are restored as **root**, change ownership to your user:
```bash
sudo chown -R $USER:$USER /home/$USER/
```

Reboot the system to apply changes:
```bash
sudo reboot
```

---

## **Additional Tips**
✅ Use `xz` compression for a **smaller backup file**:
```bash
xz -9 /home/$USER/my_backup.tar.gz
```

✅ Restore only a **specific folder** from the backup:
```bash
tar -xvpzf /home/$USER/my_backup.tar.gz -C /home/$USER/ --wildcards '*/Documents/*'
```

✅ To verify archive integrity:
```bash
tar -tvf /home/$USER/my_backup.tar.gz > /dev/null
```

✅ If hidden files were not included, back them up separately:
```bash
tar -cvpzf /home/$USER/my_hidden_files_backup.tar.gz /home/$USER/.*
```

### **Now You Have a Complete Backup and Restore Guide for Ubuntu! 🚀**

