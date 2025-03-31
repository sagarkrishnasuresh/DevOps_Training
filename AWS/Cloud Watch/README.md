# AWS CloudWatch

## 📖 **What is CloudWatch Logs?**

**Amazon CloudWatch Logs** is a service provided by AWS that allows you to collect, monitor, and analyze logs from your applications, servers, and AWS resources in real-time. It helps you track the activity of your applications, identify issues quickly, and set up alarms for important events.

## 📌 **Why Use CloudWatch Logs?**

- **Troubleshooting:** Quickly identify and solve issues in your applications.
- **Monitoring:** Stay informed about the health and performance of your systems.
- **Security:** Monitor logs for security-related events.
- **Alerts:** Receive notifications when something goes wrong.

## 🚀 **Step-by-Step Guide to Configure and Analyze CloudWatch Logs**

### Step 1: Create a Log Group

- Log into [AWS Console](https://console.aws.amazon.com/cloudwatch/).
- Go to **CloudWatch → Logs → Log Groups**.
- Click on **Create log group**.
- Enter a descriptive name, e.g., `/my-app/logs`.

### Step 2: Install and Configure CloudWatch Agent (on EC2)

- Connect to your server and run:

```bash
sudo yum update -y
sudo yum install -y amazon-cloudwatch-agent
```

### Step 2: Set up CloudWatch Agent Configuration

- Create a file named `cw-config.json`:

```json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/my-app.log",
            "log_group_name": "/my-app/logs",
            "log_stream_name": "my-app-log-stream"
          }
        ]
      }
    }
  }
}
```

- Start the agent:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:cw-config.json
```

### Step 3: View Logs in AWS Console

- Go to **CloudWatch → Logs → Log Groups**.
- Select your log group.
- Choose your log stream to see logs.

### Step 4: Analyze Logs with CloudWatch Logs Insights

- Navigate to **CloudWatch → Logs → Logs Insights**.
- Select the Log Group and run queries. Example:

```sql
fields @timestamp, @message
| filter @message like /error/i
| sort @timestamp desc
| limit 20
```

### Step 4: Create Metric Filters and Alarms

- **Metric Filter:** Counts specific log entries.
    - Go to Log Group → **Actions → Create metric filter**.
    - Define filter pattern (e.g., `ERROR`).

- **Alarm:** Notifies you when certain conditions occur.
    - Create alarms based on the metric filter to alert you of critical issues.

## 🚀 **Best Practices**

- Regularly set retention policies for your logs to optimize costs.
- Ensure clear naming conventions for easy log management.
- Secure log access with IAM policies and roles.

---

Now you're ready to monitor your applications efficiently using CloudWatch Logs!

