# 🗂️ ECR Lifecycle Policy for Image Cleanup

This document outlines the use of **Amazon ECR Lifecycle Policies** to automate the cleanup of old container images in the `admin-service-uat` repository.

---

## 🎯 Objective

To **retain only the latest 3 images** in the ECR repository and automatically delete older images. This helps:

- Reduce storage costs
- Prevent image clutter
- Ensure faster image pulls during deployment

---

## ⚙️ Lifecycle Rule Configuration

- **Rule Priority**: `1`
- **Description**: Retain only the latest 3 images
- **Image Status**: `Any` (applies to both tagged and untagged images)
- **Match Criteria**:
    - **Type**: Image count more than
    - **Count**: `3`
- **Action**: Expire (delete matching images)

---

## 🛠️ How It Works

- AWS ECR automatically tracks the **image push timestamp** (`imagePushedAt`)
- When the number of images exceeds **3**, it deletes the **oldest images**
- This policy runs **asynchronously** (AWS does not allow manual triggering)

---

## 🧪 Simulating Lifecycle Policy (Dry Run)

Before applying the policy, you can simulate its effect using a CLI script.  
Refer to the `simulate_lifecycle_dryrun.sh` script in this repo to preview which images would be deleted.

---

## 🧾 Notes

- There is no "dry run" button in AWS — the rule runs automatically within a few hours after creation.
- Tag filters (e.g., `latest`, `staging`) can be excluded or included by modifying the rule.
- You can manage lifecycle policies via the **AWS Console** or using the **AWS CLI** with a JSON policy file.

---

## 📚 References

- [AWS ECR Lifecycle Policies – Official Docs](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html)
