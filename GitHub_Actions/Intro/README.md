## Core Components of GitHub Actions

### 1. Workflow

* **Definition**: YAML files stored in your repository under `.github/workflows/`.
* **Purpose**: Automate responses to specific events occurring in the repository (e.g., push, pull request, issue creation).

### 2. Job

* **Definition**: Each workflow comprises one or more jobs.
* **Association**: Each job runs on a specified runner (environment).
* **Configuration**: Defined using the `runs-on` directive (e.g., `ubuntu-latest`, `windows-latest`).

### 3. Steps

* **Definition**: Individual tasks or actions within a job.
* **Examples**: Commands, scripts, or predefined actions.
* **Common Tasks**:

  * Building applications
  * Testing applications
  * Deploying applications

---

## Sample Workflow for Hands-On

### Workflow Example:

Create a simple workflow YAML file (`sample-workflow.yml`) in `.github/workflows/`:

```yaml
name: Sample Workflow
on: [push]

jobs:
  demo_job:
    runs-on: ubuntu-latest
    steps:
      - name: Echo Command
        run: echo "Hello, GitHub Actions!"

      - name: List Files
        run: ls -la

      - name: Read README File
        run: cat README.md
```

### Highlighted Error:

The above workflow encounters an error at the step:

```bash
cat: README.md: No such file or directory
```

**Reason:** By default, GitHub Actions runners do not have access to the repository files.

---

## Solution: Using GitHub Actions "Checkout" Action

### Introduction to Actions:

* **Actions**: Reusable units of code or scripts that perform specific tasks.
* **Marketplace**: Available on GitHub Marketplace for common operations.
* **Checkout Action**: Enables downloading (checking out) the repository files to the runner.

### Updated Workflow with Checkout Action:

```yaml
name: Sample Workflow
on: [push]

jobs:
  demo_job:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Echo Command
        run: echo "Hello, GitHub Actions!"

      - name: List Files
        run: ls -la

      - name: Read README File
        run: cat README.md
```

### Explanation:

* Adding the `actions/checkout@v3` step resolves the error by cloning the repository files to the runner environment.
* Subsequent steps now have access to repository contents.

---

