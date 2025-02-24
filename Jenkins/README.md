# Jenkins Installation and Troubleshooting

This document provides a comprehensive guide for installing [Jenkins](https://www.jenkins.io/) on Debian-based systems (e.g., Ubuntu) along with troubleshooting instructions for resolving GPG key errors during repository setup.

## Overview

[Jenkins](https://www.jenkins.io/) is an open-source automation server widely used for continuous integration and delivery. This guide covers:

- Setting up the Jenkins repository with the correct GPG key
- Installing Jenkins on your system
- Troubleshooting common GPG key errors (e.g., expired keys, invalid packet errors)
- Alternative methods for key management

## Prerequisites

Before proceeding, ensure you have:

- A Debian-based operating system (e.g., Ubuntu)
- Sudo privileges
- Java (JDK 11 or later recommended) installed on your system

To check your Java version:

```bash
java -version
```

If Java is not installed, install it via your package manager or from the [OpenJDK website](https://openjdk.java.net/).

## Installation Steps

### 1. Add the Jenkins Repository and Updated GPG Key

#### Preferred Method: Using a Keyring File

1. **Remove any existing keyring file (if present):**

   ```bash
   sudo rm /usr/share/keyrings/jenkins-keyring.gpg
   ```

2. **Fetch the updated Jenkins signing key from Ubuntu's keyserver:**

   ```bash
   sudo gpg --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA
   ```

3. **Export the key in binary format and save it to a keyring file:**

   ```bash
   sudo gpg --export 5BA31D57EF5975CA | sudo tee /usr/share/keyrings/jenkins-keyring.gpg > /dev/null
   ```

4. **Configure the Jenkins repository:**  
   Create or edit the file `/etc/apt/sources.list.d/jenkins.list` so that it contains exactly:

   ```
   deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/
   ```

5. **Update the package index:**

   ```bash
   sudo apt clean
   sudo apt update
   ```

#### Alternative Method: Legacy apt-key (Temporary Workaround)

If you continue to face issues with the keyring method:

1. **Remove the keyring file:**

   ```bash
   sudo rm /usr/share/keyrings/jenkins-keyring.gpg
   ```

2. **Add the key using apt-key:**

   ```bash
   wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
   ```

3. **Modify the repository file:**  
   Edit `/etc/apt/sources.list.d/jenkins.list` so that it contains:

   ```
   deb https://pkg.jenkins.io/debian-stable binary/
   ```

4. **Update the package index:**

   ```bash
   sudo apt update
   ```

*Note: The legacy `apt-key` method is deprecated and should only be used temporarily.*

### 2. Install Jenkins

After configuring the repository, install Jenkins with:

```bash
sudo apt install jenkins
```

### 3. Start and Enable the Jenkins Service

1. **Start the Jenkins service:**

   ```bash
   sudo systemctl start jenkins
   ```

2. **Enable Jenkins to start at boot:**

   ```bash
   sudo systemctl enable jenkins
   ```

3. **Verify Jenkins is running:**

   ```bash
   sudo systemctl status jenkins
   ```

### 4. Access Jenkins

1. Open your web browser and navigate to:

   ```
   http://localhost:8080
   ```

2. Retrieve the initial administrator password:

   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

## Troubleshooting

- **GPG Key Errors (NO_PUBKEY 5BA31D57EF5975CA):**  
  Ensure you have removed any old or expired key files and correctly fetched the updated key from the keyserver.

- **Invalid Packet Errors:**  
  If you see errors like `invalid packet (ctb=2d)`, remove the current keyring file and export the key in binary format (without the `--armor` flag).

- **Legacy apt-key Method:**  
  Use this only as a temporary workaround until the keyring method works correctly.

## Contributing

Contributions, improvements, and additional troubleshooting tips are welcome. Please open an issue or submit a pull request with your suggestions.

## License

This project is licensed under the [MIT License](LICENSE).

