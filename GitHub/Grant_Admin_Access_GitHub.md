# GitHub Repository Transfer: Personal Account ➔ Organization

## Objective

To transfer the `iter-devops` repository (or any personal repo) to a **GitHub Organization** so that you can assign roles like Admin, Write, Read, etc., and manage access more securely.

---

## Prerequisites

* You must be the **owner** of the personal repository.
* You must be the **owner** or have the required permissions in the target **GitHub Organization**.
* The repository **should not be a fork** (forks cannot be transferred unless the parent is transferred too).

---

## Step-by-Step: Create an Organization (if not already created)

1. Go to: [https://github.com/account/organizations/new](https://github.com/account/organizations/new)
2. Choose a plan (Free is sufficient for most needs).
3. Enter:

   * **Organization account name** (e.g., `etravelmate-devops`)
   * **Contact email**
4. Click **Create organization**.

---

## Step-by-Step: Transfer Repository to Organization

1. Navigate to your repository (e.g., `https://github.com/your-username/iter-devops`).
2. Click on the **Settings** tab.
3. Scroll to the bottom to find the **“Danger Zone”** section.
4. Click **Transfer ownership**.
5. In the transfer dialog:

   * Enter the organization name as the **new owner** (e.g., `etravelmate-devops`).
   * Type the repository name to confirm (e.g., `iter-devops`).
6. Click **I understand, transfer this repository**.

---

## Post-Transfer Actions

Once the repository is successfully moved:

### 1. Update Local Git Remote URLs

```bash
git remote set-url origin https://github.com/etravelmate-devops/iter-devops.git
```

### 2. Re-Invite Collaborators

* Go to the repo → **Settings** → **Manage access**
* Add members or teams
* Assign roles: Admin, Write, Read, Maintain, etc.

### 3. Reconfigure GitHub Actions/Secrets

Secrets are **not transferred** automatically. Re-add them in the new repository under:

```
Settings → Secrets and Variables → Actions
```

---

## Important Notes

| Point        | Detail                                                      |
| ------------ | ----------------------------------------------------------- |
| Forks        | Cannot be transferred unless the parent is transferred too  |
| Issues/Wiki  | All content (commits, issues, wiki) will move with the repo |
| URLs         | Old repo URL will redirect to the new one                   |
| CI/CD        | Update any automation pointing to the old repo              |
| GitHub Pages | Pages settings might need reconfiguration after transfer    |

---

## Example Use Case

You're managing `iter-devops` from a personal GitHub account but want to:

* Grant **Admin** access to team members
* Organize repositories (backend, frontend, infra) under one account
* Enable **Team-based role management**

Transferring to an **Organization** is the best solution.
