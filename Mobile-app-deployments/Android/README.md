# 📁 Android Deployment Automation – Google Play Store

This document serves as a placeholder and checklist for automating the **Android mobile app deployment** using **GitHub Actions** and **Fastlane**.

Once discussions with the Android development team are complete, this README will be updated with exact steps, secrets, workflows, and configurations used in the process.

---

## 📦 Purpose

To automate the building, signing, and publishing of Android application bundles (`.aab`) to the Google Play Store with minimal manual intervention.

---

## 🔄 Planned CI/CD Workflow

1. Trigger deployment (manually or on tag push)
2. Build app using Gradle (`./gradlew bundleRelease` or similar)
3. Sign app using secure keystore credentials
4. Upload to Google Play Store using Fastlane
5. Track success/failure through GitHub Actions logs

---

## 📋 To-Do Checklist (Initial Phase)

### 🔍 Information to Collect from Android Developer

* [ ] Build commands (Gradle task and build type)
* [ ] Flavors/variants in use (e.g., `staging`, `prod`)
* [ ] Signing config details (keystore, alias, passwords)
* [ ] Play Store track used (internal, beta, production)
* [ ] Release notes or changelog practice

### 🏗 Fastlane Setup (Planned)

* [ ] Initialize Fastlane in `android/app/`
* [ ] Configure `Fastfile` with a `release` lane
* [ ] Set up `Appfile` with package name and Google credentials

### 🔧 GitHub Actions (Planned)

* [ ] Setup workflow YAML file in `.github/workflows/`
* [ ] Install required JDK and dependencies
* [ ] Decode secrets (keystore, API JSON) into usable files
* [ ] Trigger Fastlane from workflow

---

## 🔐 Secrets to Be Managed

| Secret Key          | Description                                         |
| ------------------- | --------------------------------------------------- |
| `KEYSTORE_FILE`     | Base64-encoded `.jks` file for signing              |
| `KEYSTORE_PASSWORD` | Password for the keystore                           |
| `KEY_ALIAS`         | Alias name used inside the keystore                 |
| `KEY_PASSWORD`      | Password for the signing key                        |
| `PLAY_STORE_JSON`   | Base64-encoded Google Play API service account JSON |

> Secrets will be stored securely in GitHub under:
> `Settings > Secrets and Variables > Actions`

---

## 📚 References (For Future Use)

* [Fastlane for Android](https://docs.fastlane.tools/getting-started/android/setup/)
* [Upload to Play Store](https://docs.fastlane.tools/actions/upload_to_play_store/)
* [GitHub Actions Docs](https://docs.github.com/en/actions)
* [Play Console API Access](https://developers.google.com/android-publisher)

---

> 📝 This document will be expanded as real deployment steps are finalized after collaboration with the Android team.
