**Title: Setting Up a GitHub Self-Hosted Runner on Local Machine**

---

### Objective

To configure and register a GitHub Actions self-hosted runner on a local Linux machine for executing workflows within a private or local environment.

---

### Prerequisites

* A GitHub repository where the runner will be registered
* A Linux-based system with:

  * Internet access
  * `curl`, `tar`, `unzip` installed
* GitHub account with access to the target repository

---

### Step-by-Step Setup Instructions

#### ✅ 1. Navigate to Your Repository

1. Go to your GitHub repository (e.g., `github.com/username/repo`)
2. Click on **Settings** > **Actions** > **Runners**
3. Click **"New self-hosted runner"** and choose:

   * OS: Linux
   * Architecture: x64

You will see a set of commands provided by GitHub for setup.

---

#### ✅ 2. Set Up the Runner on Your Local Machine

Run the following commands (use the exact versions GitHub provides):

```bash
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.313.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.313.0/actions-runner-linux-x64-2.313.0.tar.gz
tar xzf actions-runner-linux-x64-2.313.0.tar.gz
```

---

#### ✅ 3. Configure the Runner

Replace `<URL>` and `<TOKEN>` with the values from GitHub UI:

```bash
./config.sh --url https://github.com/username/repo --token <TOKEN>
```

You’ll be prompted to:

* Accept the default **runner group** (`Default`)
* Set a **runner name** (or accept default)
* Set the **working directory** (or accept `_work`)

---

#### ✅ 4. Start the Runner

To run it interactively:

```bash
./run.sh
```

> The runner is now live and waiting for jobs. Leave this terminal open.

---

#### ✅ 5. (Optional) Install as a Service

To run the runner in the background as a system service:

```bash
sudo ./svc.sh install
sudo ./svc.sh start
```

To stop or uninstall:

```bash
sudo ./svc.sh stop
sudo ./svc.sh uninstall
```

---

### Verification

* Go to your repository → **Settings > Actions > Runners**
* You should see your runner listed and in green (idle or busy)

---

### Notes

* Make sure the runner has access to required tools (e.g., Docker, kubectl, AWS CLI)
* Runners are repo-specific unless added at the org level
* One runner can only execute one job at a time

---

**End of Document**

