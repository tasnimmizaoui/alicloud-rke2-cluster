# Alibaba Cloud RKE2 Cluster Infrastructure

This repository contains the Infrastructure as Code (IaC) configurations and cloud-init bootstrap scripts required to deploy a highly available, production-ready Kubernetes cluster on Alibaba Cloud. The cluster is powered by **RKE2 (v1.36.2)** and entirely provisioned via **Terraform**.

##  Architecture Overview

* **Cloud Provider:** Alibaba Cloud (ECS, VPC, vSwitches, Security Groups)
* **Provisioning Tool:** Terraform
* **Kubernetes Distribution:** RKE2 (Rancher Kubernetes Engine 2)
* **Version:** `v1.36.2+rke2r1`
* **CNI (Networking):** Calico
* **Ingress Controller:** Disabled at bootstrap (prepared for independent/custom Traefik Helm deployment)
* **Host OS:** Ubuntu
* **Node Access:** Secure non-root environment via `ecs-user`

##  Key Features & Automation

1. **Infrastructure as Code (IaC):**
   * Automated creation of the networking backbone (VPC, vSwitch, Security Groups).
   * Dynamic provisioning of Master (Control Plane) and Worker ECS instances using SSD storage (`cloud_essd`).
2. **Zero-Touch Cluster Bootstrapping:**
   * Utilizes Terraform template files (`.tpl`) to dynamically inject variables (like the cluster token and Master IP) directly into the Alibaba Cloud `user_data` payload.
   * Ensures perfect boot-sequencing: the Worker node automatically waits for the Master node's IP to be assigned before initializing its join sequence.
3. **Security First:**
   * Default root access is bypassed. Cloud-init automatically provisions a non-root `ecs-user` with passwordless sudo.
   * Alibaba Cloud SSH keys are automatically synced to the restricted user profile.
4. **Modern Kubernetes Baseline:**
   * Directly installs the v1.36+ architecture.
   * Enforces Calico for advanced network policies out of the box.
   * Disables the packaged RKE2 ingress controllers to allow for granular, manual Helm deployments of routing infrastructure later.

##  Deployment Instructions

### 1. Prerequisites
* Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
* Configure your Alibaba Cloud API credentials locally.

### 2. Generate a Cluster Token
Generate a secure, random token that the Worker nodes will use to authenticate with the Master node. Run this locally:
```bash
openssl rand -hex 16
```
---
### Access the Cluster
Once Terraform finishes, allow ~3 to 5 minutes for the cloud-init scripts to run, install RKE2, and initialize the Calico CNI.

SSH into your Master node as ecs-user:

```bash
ssh -i /path/to/your/key.pem ecs-user@<MASTER_PUBLIC_IP>
```
### Note on Shell Environment:
> The automation script appends the RKE2 binary path (/var/lib/rancher/rke2/bin) directly to your user's shell profile. If your SSH session connects exactly as the script finishes executing, the new path might not be active yet.

To ensure kubectl is recognized immediately without logging out and back in, always source your shell profile upon first entry:

```bash
source ~/.bashrc
```
