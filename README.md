# WordPress Terraform Deployment

A fully automated Infrastructure as Code (IaC) solution for deploying WordPress on AWS using Terraform, with one-click deployment and teardown scripts.

## 🎯 Overview

This project demonstrates modern DevOps practices by providing a complete WordPress deployment pipeline on AWS. It showcases infrastructure automation, cloud security best practices, and operational efficiency through scripted deployment management.

**Key Technologies:** Terraform, AWS (EC2, VPC, Security Groups), Shell Scripting, Cloud-Init

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (v1.0+)
- SSH key pair created in AWS (default: `ubuntu-2025`)

### One-Click Deployment
```bash
# Deploy WordPress infrastructure
./scripts/runSite.sh

# Destroy all resources when done
./scripts/destroySite.sh
```

That's it! The scripts handle everything from infrastructure provisioning to opening your WordPress site in the browser.

## 📁 Project Structure

```
├── main.tf                 # Core Terraform configuration
├── variables.tf            # Variable definitions
├── terraform.tfvars        # Variable values
├── cloud-init.yaml         # WordPress installation script
├── provider.tf             # AWS provider configuration
├── scripts/
│   ├── runSite.sh         # Automated deployment script
│   └── destroySite.sh     # Automated teardown script
├── docker-compose.yml      # LocalStack for testing
└── Makefile               # Convenience commands
```

## 🏗️ Architecture

- **EC2 Instance**: Hosts WordPress application (t2.micro)
- **Security Group**: Configured for HTTP (80) and SSH (22) access
- **Cloud-Init**: Automated LAMP stack setup and WordPress installation
- **Public IP**: Direct internet access to WordPress site

## 🛠️ Features

### ✅ Current Implementation
- **Automated Infrastructure**: One-command deployment and teardown
- **Security**: Proper security group configuration and key management
- **Monitoring**: Real-time deployment status and health checks
- **Cost Optimization**: Uses free-tier eligible resources
- **Local Testing**: LocalStack integration for development

### 🚀 Production Enhancements (Roadmap)

This project serves as a foundation for enterprise-grade deployments. Recommended improvements include:

#### Scalability & High Availability
- **Container Orchestration**: Migrate to EKS (Kubernetes) or ECS for auto-scaling
- **Load Balancing**: Application Load Balancer with multiple AZs
- **Database**: Amazon RDS with Multi-AZ deployment
- **Content Delivery**: CloudFront CDN integration
- **Auto Scaling**: EC2 Auto Scaling Groups based on demand

#### DevOps & CI/CD
- **CI/CD Pipeline**: GitHub Actions or AWS CodePipeline
- **Environment Management**: Separate dev/staging/prod environments
- **Infrastructure Testing**: Terratest for automated testing
- **Monitoring**: CloudWatch, Grafana, or Datadog integration
- **Secrets Management**: AWS Secrets Manager or HashiCorp Vault

#### Security & Compliance
- **SSL/TLS**: ACM certificates with automatic renewal
- **WAF**: Web Application Firewall protection
- **IAM**: Least-privilege access policies
- **Backup**: Automated EBS snapshots and S3 backups
- **Compliance**: SOC 2, PCI DSS configurations

## 🎓 Learning Outcomes

This project demonstrates proficiency in:

- **Infrastructure as Code**: Terraform best practices and modular design
- **Cloud Architecture**: AWS services integration and security
- **Automation**: Shell scripting and deployment automation
- **DevOps Practices**: GitOps, infrastructure testing, and operational procedures
- **System Administration**: Linux, web servers, and application deployment

## 💰 Cost Considerations

- **Free Tier Eligible**: Uses t2.micro instance and minimal resources
- **Estimated Cost**: ~$8-15/month if exceeding free tier limits
- **Cost Optimization**: Automatic teardown prevents unnecessary charges

## 🔧 Usage Examples

```bash
# Standard deployment
./scripts/runSite.sh

# Check WordPress status
terraform output wordpress_public_ip
curl http://$(terraform output -raw wordpress_public_ip)

# Clean teardown
./scripts/destroySite.sh
```

## 🤝 Contributing

This project welcomes contributions! Areas for enhancement:
- Multi-AZ deployment configurations
- Database separation and RDS integration
- Container orchestration examples
- CI/CD pipeline templates
- Monitoring and logging solutions

## 📝 License

MIT License - Feel free to use this project for learning, development, or as a foundation for production deployments.

---

**💡 Pro Tip**: This project is designed to be recruiter-friendly, showcasing practical DevOps skills and cloud architecture understanding. Each component demonstrates real-world infrastructure challenges and solutions.
