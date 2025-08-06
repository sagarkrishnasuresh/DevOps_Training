# SSL/TLS Certificate Generation and Usage for Security

## 1. What is an SSL/TLS Certificate?

An **SSL/TLS certificate** is a digital certificate that authenticates a website's identity and enables an encrypted connection between a web server and a client (browser). It ensures:

* **Confidentiality**: Data exchanged is encrypted.
* **Integrity**: Data cannot be modified during transmission.
* **Authentication**: Confirms the website is legitimate.

---

## 2. Steps to Generate SSL/TLS Certificates

You can generate SSL/TLS certificates using OpenSSL. Below are two common scenarios:

---

### A. Generating a Certificate Signing Request (CSR)

A **CSR** is sent to a Certificate Authority (CA) to issue a signed SSL/TLS certificate. It contains:

* The public key of the server.
* Distinguished Name (DN) details (organization, domain, location).

#### Command:

```bash
sudo openssl req -new -newkey rsa:2048 -nodes -keyout app01.key -out app01.csr
```

#### Explanation:

* `openssl req`: Creates a certificate request.
* `-new`: Generates a new CSR.
* `-newkey rsa:2048`: Creates a new 2048-bit RSA key pair.
* `-nodes`: Skips encryption for the private key (no password required for server restarts).
* `-keyout app01.key`: Saves the private key file.
* `-out app01.csr`: Saves the certificate signing request.

#### Input Fields Example:

* **Country Name (C):** SG
* **State/Province (ST):** Capital Tower
* **Locality (L):** CT
* **Organization (O):** KodeKloud
* **Organizational Unit (OU):** Education
* **Common Name (CN):** app01.com
* **Email Address:** [admin@kodekloud.com](mailto:admin@kodekloud.com)

**Output Files:**

* `app01.key` → Private key (keep secure).
* `app01.csr` → CSR file to be sent to a CA.

---

### B. Generating a Self-Signed Certificate

A **self-signed certificate** is created for testing or internal use (not validated by a public CA).

#### Command:

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout app01.key -out app01.crt
```

#### Explanation:

* `-x509`: Creates a self-signed certificate.
* `-nodes`: Skips key encryption.
* `-days 365`: Valid for 1 year.
* `-newkey rsa:2048`: Generates a new RSA private key.
* `-keyout app01.key`: Outputs the private key.
* `-out app01.crt`: Outputs the certificate file.

**Output Files:**

* `app01.key` → Private key.
* `app01.crt` → Self-signed certificate.

---

## 3. How Certificates Are Used for Security

### Step 1: Install Certificate on Web Server

Place the certificate and key in secure directories (e.g., `/etc/httpd/certs/`) and configure your web server:

**Apache Example:**

```apache
<VirtualHost *:443>
    ServerName app01.com
    SSLEngine on
    SSLCertificateFile /etc/httpd/certs/app01.crt
    SSLCertificateKeyFile /etc/httpd/certs/app01.key
</VirtualHost>
```

Restart the web server:

```bash
sudo systemctl restart httpd
```

---

### Step 2: Enable HTTPS and Secure Communication

Once installed, access your site using `https://app01.com`.

* For **CA-signed certificates**, browsers will trust the connection.
* For **self-signed certificates**, browsers will show a warning (suitable only for testing).

---

### Step 3: SSL/TLS Handshake Process

1. **Browser connects** to `https://app01.com`.
2. **Server sends** its certificate (`app01.crt`).
3. **Browser validates** the certificate (trusted CA, CN match, expiry).
4. **Session key exchange** is performed securely.
5. **Data is encrypted** using the session key for secure communication.

---

## 4. Use Cases

* **CSR + CA-signed certificate:** For public, production websites.
* **Self-signed certificate:** For internal or testing environments.

---

## 5. Best Practices

✅ Keep private keys (`app01.key`) secure:

```bash
chmod 600 /etc/httpd/certs/app01.key
```

✅ Use **CA-signed certificates** for production.
✅ Renew certificates before expiry.
✅ Use strong keys (2048-bit RSA or higher).

---

## 6. File Summary

* `/etc/httpd/csr/app01.csr` → Certificate Signing Request (CSR for CA).
* `/etc/httpd/certs/app01.crt` → Final SSL certificate.
* `/etc/httpd/certs/app01.key` → Private key (keep secure).

---

## 7. Visual Overview: SSL/TLS Handshake

```mermaid
sequenceDiagram
    participant Browser
    participant Server

    Browser->>Server: Connect via HTTPS
    Server-->>Browser: Sends SSL Certificate
    Browser->>Browser: Validate Certificate (CA, CN, Expiry)
    Browser->>Server: Generate Session Key (Encrypted)
    Server-->>Browser: Confirm Session Key
    Browser<->>Server: Encrypted Data Exchange
```
