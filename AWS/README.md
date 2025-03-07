# AWS Basics - DevOps Training

## Introduction
Amazon Web Services (AWS) is a comprehensive cloud computing platform that offers a wide range of services for computing, storage, networking, security, and more. As part of DevOps training, understanding AWS services like VPC, EC2, ECR, S3, and others is crucial for efficient cloud-based application deployment and management.

## Key AWS Services

### 1. **Virtual Private Cloud (VPC)**
- AWS VPC allows you to create an isolated network in the AWS cloud.
- Components of VPC:
    - **Subnets**: Public and private sub-networks within the VPC.
    - **Internet Gateway**: Allows public access to the internet.
    - **NAT Gateway**: Enables private subnets to access the internet securely.
    - **Route Tables**: Defines rules for traffic routing within the VPC.
    - **Security Groups & Network ACLs**: Control inbound and outbound traffic.

### 2. **Elastic Compute Cloud (EC2)**
- Provides resizable compute capacity in the cloud.
- Key Features:
    - **Instance Types**: Different sizes and configurations (e.g., t2.micro, t3.medium).
    - **Elastic Block Store (EBS)**: Persistent storage volumes for EC2 instances.
    - **AMI (Amazon Machine Image)**: Pre-configured OS images.
    - **Key Pairs**: Secure SSH access to instances.
    - **Auto Scaling & Load Balancing**: Automatic scaling based on demand.

### 3. **Elastic Container Registry (ECR)**
- Fully managed container registry to store, manage, and deploy Docker container images.
- Works with Amazon Elastic Kubernetes Service (EKS) and AWS Fargate.
- Commands to use ECR:
    - Authenticate with AWS CLI: `aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com`
    - Push image to ECR:
      ```sh
      docker tag my-app:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-app:latest
      docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-app:latest
      ```

### 4. **Simple Storage Service (S3)**
- Object storage for storing and retrieving any amount of data.
- Features:
    - **Buckets**: Containers for storing data.
    - **Access Control**: Public and private access, IAM permissions.
    - **Lifecycle Policies**: Automatically move objects between storage classes (Standard, IA, Glacier).
    - **Versioning**: Maintain multiple versions of objects.
    - **Static Website Hosting**: Host static sites directly from an S3 bucket.

### 5. **Identity and Access Management (IAM)**
- Manages AWS users, groups, roles, and permissions securely.
- Key Components:
    - **Users**: Individual AWS accounts with credentials.
    - **Groups**: Collections of users with assigned policies.
    - **Roles**: Assigned permissions for AWS services or federated users.
    - **Policies**: JSON-based rules defining permissions.

### 6. **Elastic Kubernetes Service (EKS)**
- Managed Kubernetes service for running containerized applications.
- Key Features:
    - Integration with EC2, Fargate, and ECR.
    - Kubernetes control plane managed by AWS.
    - Autoscaling for workloads.

### 7. **Relational Database Service (RDS)**
- Managed relational database service supporting MySQL, PostgreSQL, SQL Server, and more.
- Features:
    - Automated backups and multi-AZ replication.
    - Scaling based on demand.
    - Secure access with IAM and VPC integration.

    
### 8. **Elastic Load Balancer (ELB)**
- Distributes incoming traffic across multiple EC2 instances.
- Types of Load Balancers:
    - **Application Load Balancer (ALB)**: Works at the application layer (HTTP/HTTPS).
    - **Network Load Balancer (NLB)**: Works at the transport layer (TCP/UDP).
    - **Classic Load Balancer (CLB)**: Legacy load balancing solution.

## Conclusion
Understanding AWS services is crucial for effective cloud infrastructure management. This guide provides a fundamental overview of AWS services commonly used in DevOps workflows. These services help in building scalable, secure, and highly available applications in AWS.

