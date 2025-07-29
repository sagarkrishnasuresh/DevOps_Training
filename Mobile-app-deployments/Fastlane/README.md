# **Android Build & Fastlane CI/CD Workflow Documentation**

This document details the setup and integration of **Fastlane** for Android builds within a GitHub Actions CI/CD pipeline. It outlines prerequisites, configuration, workflow implementation, artifact handling, and best practices.

---

## **1. Ruby & Fastlane Setup**

Fastlane requires **Ruby** and **Bundler** for dependency management.

### Install Ruby

```bash
sudo apt-get install ruby-full
```

### Install Bundler

```bash
gem install bundler
```

### Install Fastlane

```bash
sudo gem install fastlane -NV
```

### Verify Installation

```bash
fastlane --version
```

---

## **2. Pre-installations on CI/CD Runner**

Ensure the following are installed on your **self-hosted runner** or **GitHub Actions runner**:

* **Flutter SDK** → `/opt/flutter/bin`
* **Android SDK** → `/home/ubuntu/Android/Sdk`
* **Ruby with Bundler installed**
* **Fastlane installed globally**

Verification commands:

```bash
flutter --version
sdkmanager --list
ruby --version
fastlane --version
```

---

## **3. Fastlane Configuration in Service Repository**

The Fastlane setup resides in the **Android module** of the mobile repository.

### Directory Structure

```
android/
  └── fastlane/
       ├── Fastfile
       ├── Appfile
       ├── Pluginfile
  Gemfile
```

### Fastfile

Defines lanes to build APK and AAB:

```ruby
default_platform(:android)

platform :android do
  desc "Build AAB & APK using Fastlane"
  lane :build do
    sh "flutter clean"
    sh "flutter pub get"
    sh "flutter build appbundle --flavor #{ENV['FLAVOR']} --dart-define=FLAVOR=#{ENV['FLAVOR']}"
    sh "flutter build apk --flavor #{ENV['FLAVOR']} --dart-define=FLAVOR=#{ENV['FLAVOR']}"
  end
end
```

### Appfile

Defines the package identifier for the Android app.

```ruby
package_name("com.example.app") # Replace with your app's package ID
```

### Pluginfile

Currently unused but can be extended for plugins:

```ruby
plugins_path = File.join(File.dirname(__FILE__), 'Pluginfile')
```

### Gemfile

Ruby gem dependencies:

```ruby
source "https://rubygems.org"

gem "fastlane"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
```

---

## **4. GitHub Actions Workflow for Android Builds**

This workflow builds APK and AAB artifacts using Fastlane and Flutter.

### Workflow Overview

* **Trigger**: Manual dispatch (`workflow_dispatch`).
* **Inputs**:

  * **environment**: `staging` or `production`.
  * **app\_name**: `customer-app` or `driver-app`.
  * **customer\_branch / driver\_branch**: Git branch to build from.

### Workflow File

```yaml
name: Android Build

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Deployment environment (Currently for staging only!)'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
      app_name:
        description: 'Mobile app to build'
        required: true
        default: 'customer-app'
        type: choice
        options:
          - customer-app
          - driver-app
      customer_branch:
        description: 'Branch to build from (for customer-app)'
        required: false
        type: string
      driver_branch:
        description: 'Branch to build from (for driver-app)'
        required: false
        type: string
```

### Jobs

#### **1. setup-system**

Verifies tools and environment setup:

* Checks **jq**, **Fastlane**, and **Flutter**.
* Installs if missing.

#### **2. build-apk**

Key steps:

* **Checkout DevOps repo** (for keystore and Firebase configs).

* **Branch determination** for app-specific builds.

* **Checkout app repository** from selected branch.

* **Setup local.properties** for Android SDK and Flutter versions.

* **Copy Keystore and Firebase files**.

* **Run Fastlane build**:

  ```yaml
  - name: 🔨 Build App (AAB + APK) using Fastlane
    run: |
      export PATH=/opt/flutter/bin:$PATH
      bundle config set --local path 'vendor/bundle'
      bundle install --jobs 4 --retry 3
      bundle exec fastlane android build
    working-directory: ${{ env.APP_NAME }}-mob/android
  ```

* **Upload Artifacts**:

  * AAB → `build/app/outputs/bundle/...`
  * APK → `build/app/outputs/flutter-apk/...`

* **Generate Build Summary**: Displays app, environment, flavor, and artifact info.

* **Runner Cleanup**: Clears caches (Flutter, Gradle, npm) and frees disk space.

---

## **5. Firebase App Distribution (Optional for Staging)**

A commented-out step is included for future Firebase integration:

```yaml
# - name: 🚀 Upload Staging APK to Firebase App Distribution
#   if: env.FLAVOR == 'stg'
#   run: |
#     export PATH=/opt/flutter/bin:$PATH
#     bundle exec fastlane android upload_stg_firebase
#   working-directory: ${{ env.APP_NAME }}-mob/android
#   env:
#     FIREBASE_APP_ID: ${{ secrets.FIREBASE_APP_ID }}
#     FIREBASE_TESTERS: ${{ secrets.FIREBASE_TESTERS }}
#     FIREBASE_GROUPS: ${{ secrets.FIREBASE_GROUPS }}
#     FIREBASE_CLI_TOKEN: ${{ secrets.FIREBASE_CLI_TOKEN }}
#     FLAVOR: ${{ env.FLAVOR }}
```

---

## **6. Artifact Naming Convention**

Build artifacts are timestamped:

```
<app_name>-<flavor>-<timestamp>
```

Artifacts:

* AAB: `build/app/outputs/bundle/<flavor>/app-<flavor>-release.aab`
* APK: `build/app/outputs/flutter-apk/app-<flavor>-release.apk`

---

## **7. Execution Flow Summary**

1. **Manual Trigger** → Provide environment, app name, branch.
2. **Setup System** → Validate dependencies.
3. **Checkout DevOps & App Repos**.
4. **Prepare Config Files** → local.properties, keystore, google-services.json.
5. **Build Artifacts** → Fastlane builds APK and AAB.
6. **Upload Artifacts** → GitHub artifact store.
7. **Clean Runner** → Remove caches and free disk.

---

## **8. Next Steps**

* Enable **Firebase App Distribution lane** for staging testing.
* Add **Play Store upload lane** for production releases.
* Integrate build versioning automation.

---

### ✅ **Outcome**

This workflow automates Android build generation via Fastlane, integrates seamlessly with GitHub Actions, and outputs signed APK and AAB artifacts ready for distribution or deployment.

---
