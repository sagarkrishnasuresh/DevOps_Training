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

