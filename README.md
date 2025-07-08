# AUTHOR GORAV MADAN
# Azure Infra Deployment with Terraform & Ansible

This repo provisions a Linux VM in Azure using Terraform and configures it with Ansible.

## 📦 Project Structure

- `terraform/`: Infrastructure code
- `ansible/`: Ansible configuration
- `azure-pipelines.yml`: CI/CD pipeline

## ✅ Prerequisites

- Azure subscription
- Azure DevOps project
- SSH public key
- Pipeline secrets:

  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`
  - `ARM_TENANT_ID`
  - `ARM_SUBSCRIPTION_ID`
  - `SSH_PUBLIC_KEY`

## 🚀 How to Run

1. Clone the repo and create pipeline in Azure DevOps
2. Connect to this GitHub repo
3. Add the pipeline secrets
4. Run the pipeline with ADO

✅ Output
Resource Group, VM, VNet, NIC, Public IP created
Ansible configures VM with NGINX


🔁 Idempotency
Re-running the pipeline won't cause duplicate resources

Thanks for reviewing this!
