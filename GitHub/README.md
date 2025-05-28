# Git & GitHub Basics

This README provides a quick reference guide for essential Git and GitHub commands. It is intended for beginners or as a quick refresher.

---

## 📘 Basic Commands

### 📌 Git Setup

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Set your Git username and email globally.

---

### 📁 Initialize a Repository

```bash
git init
```

Creates a new local Git repository.

---

### 🔗 Connect to a Remote Repository (GitHub)

```bash
git remote add origin https://github.com/username/repo-name.git
```

Links your local repo with a remote GitHub repo.

---

### 📄 Check Status

```bash
git status
```

Displays the status of files in the working directory and staging area.

---

### ➕ Add Files

```bash
git add filename         # Add a specific file
git add .                # Add all modified and new files
```

Adds changes to the staging area.

---

### ✅ Commit Changes

```bash
git commit -m "Commit message"
```

Commits the staged changes with a descriptive message.

---

### ⬆️ Push Changes

```bash
git push origin main
```

Pushes commits to the main branch on the remote repository.

---

### ⬇️ Pull Changes

```bash
git pull origin main
```

Fetches and merges changes from the remote repository.

---

### 📎 Clone a Repository

```bash
git clone https://github.com/username/repo-name.git
```

Copies a remote repository to your local machine.

### 🔍 Check Remote Repository URL

```bash
git remote -v
```

Displays the URL of the remote repository linked to your local project.

---

## 💡 Advanced Commands

### 🌿 Branch Management

```bash
git branch new-branch         # Create new branch
git checkout new-branch       # Switch to branch
git checkout -b new-branch    # Create and switch
```

---

### 🔄 Merge Branches

```bash
git checkout main
git merge new-branch
```

Merges `new-branch` into `main`.

---

### 🗑️ Delete Files

```bash
git rm filename
```

Removes a file from the working directory and stages the removal.

---

### ❌ Undo Changes

```bash
git restore filename           # Discard changes in working directory
git reset HEAD filename        # Unstage a file
```

---

### 🔍 View History

```bash
git log
```

Shows the commit history.

---

### 🧹 Clean Untracked Files

```bash
git clean -f
```

Removes untracked files.

---

## 🔁 Common Tips

* Always pull before pushing changes.
* Use meaningful commit messages.
* Regularly push changes to avoid data loss.
* Use branches for new features or bug fixes.

---

## 📚 Resources

* [Git Official Documentation](https://git-scm.com/doc)
* [GitHub Docs](https://docs.github.com/)

---

Feel free to fork or clone this repository for your personal use.
