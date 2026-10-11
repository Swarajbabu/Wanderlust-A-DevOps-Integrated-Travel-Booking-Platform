<div align="center">

# 🌍 Wanderlust: Production DevOps & Cloud Architecture

### Enterprise-Grade GitOps, CI/CD Pipeline, AWS EKS Orchestration & Observability Suite

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)](https://grafana.com/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)

<br/>

[**🌐 Live Application**](http://a51fe5ad2863047968c94d092fc4c0ce-412112320.ap-south-1.elb.amazonaws.com/listings) • [**⚙️ Jenkins CI/CD**](http://3.110.81.86:8080/job/wanderlust-pipeline/) • [**📊 Grafana Dashboard**](http://localhost:3000) • [**📋 Teacher Viva Sheet**](./DEMO_CHEATSHEET.md)

</div>

---

## 📌 Executive Overview

**Wanderlust** is a production-grade full-stack travel booking application that has been completely transformed into a highly available, fault-tolerant, and observable cloud-native platform. 

This repository implements a complete **10-Tool DevOps Lifecycle**:
1. **Source Code Management:** Git & GitHub
2. **Containerization & Local Dev:** Docker & Docker Compose
3. **Infrastructure as Code (IaC):** Terraform
4. **Cloud Infrastructure:** AWS (VPC, Multi-AZ Subnets, IGW, Route Tables, EC2, ECR, EKS, ELB)
5. **Continuous Integration & Delivery (CI/CD):** Jenkins (Declarative Pipeline with GitHub Webhooks)
6. **Container Orchestration:** Kubernetes (AWS EKS v1.30 with zero-downtime Rolling Updates)
7. **Cluster Monitoring & Metrics:** Prometheus Operator & Node Exporter
8. **Real-time Observability & SRE Dashboards:** Grafana (Golden Signals & USE Method)

---

## 🏗️ End-to-End DevOps Architecture

```
                                  DEV-TO-CLOUD ARCHITECTURE
                                  
  ┌────────────────┐         git push          ┌───────────────────────────┐
  │   Developer    │ ────────────────────────> │   GitHub Repository       │
  └────────────────┘                           └─────────────┬─────────────┘
                                                             │
                                                  Webhook    │ (HTTP POST on Push)
                                                             ▼
                                               ┌───────────────────────────┐
                                               │   Jenkins CI/CD Server    │
                                               │      (AWS EC2 t3.micro)   │
                                               └─────────────┬─────────────┘
                                                             │
                      ┌──────────────────────────────────────┼──────────────────────────────────────┐
                      │                                      │                                      │
                      ▼                                      ▼                                      ▼
               [Stage 1: Checkout]                  [Stage 2: Docker Build]                [Stage 3: Push to ECR]
               SCM Git revision pull                Builds & tags Docker image             AWS IAM authenticate &
                                                    (Node 20 Alpine Linux)                 Push to wanderlust-app
                                                                                            
                                                             │
                                                             ▼
                                                    [Stage 4: Deploy EKS]
                                                    kubectl set image &
                                                    rollout status verification
                                                             │
                                                             ▼
  ┌────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │                                      AWS VIRTUAL PRIVATE CLOUD (VPC)                                   │
  │                                                                                                        │
  │   ┌────────────────────────────────────────────────────────────────────────────────────────────────┐   │
  │   │                                AWS Classic Elastic Load Balancer (ELB)                         │   │
  │   └───────────────────────────────────────────────┬────────────────────────────────────────────────┘   │
  │                                                   │ Traffic Split (Round Robin)                        │
  │                   ┌───────────────────────────────┴───────────────────────────────┐                    │
  │                   ▼                                                               ▼                    │
  │   ┌──────────────────────────────┐                                ┌──────────────────────────────┐     │
  │   │ Public Subnet A (ap-south-1a)│                                │ Public Subnet B (ap-south-1b)│     │
  │   │   Worker Node 1 (EC2)        │                                │   Worker Node 2 (EC2)        │     │
  │   │   ┌──────────────────────┐   │                                │   ┌──────────────────────┐   │     │
  │   │   │  Pod 1 (Wanderlust)  │   │                                │   │  Pod 3 (Wanderlust)  │   │     │
  │   │   └──────────────────────┘   │                                │   └──────────────────────┘   │     │
  │   │   ┌──────────────────────┐   │                                │                              │     │
  │   │   │  Pod 2 (Wanderlust)  │   │                                │                              │     │
  │   │   └──────────────────────┘   │                                │                              │     │
  │   └──────────────────────────────┘                                └──────────────────────────────┘     │
  │                                                   ▲                                                    │
  │                                                   │ Scrapes Metrics (15s interval)                     │
  │                                   ┌───────────────┴───────────────┐                                    │
  │                                   │  Namespace: `monitoring`      │                                    │
  │                                   │  ├── Prometheus Operator      │                                    │
  │                                   │  ├── Node Exporters           │                                    │
  │                                   │  └── Grafana Dashboard (v2)   │                                    │
  │                                   └───────────────────────────────┘                                    │
  └────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📸 Production Screenshots & Visual Proof

### 1. Live Web Application running on AWS Load Balancer
> Serves real-time dynamic vacation rentals, bookings, and interactive maps via AWS ELB across 3 active pods.
![Live Website on AWS ELB](./assets/devops/website_live.png)

### 2. Jenkins Automated CI/CD Pipeline
> Fully automated GitHub Webhook trigger executing Checkout ➔ Docker Build ➔ ECR Push ➔ Zero-Downtime EKS Rollout.
![Jenkins Pipeline Build History](./assets/devops/jenkins_pipeline.png)

### 3. Production Grafana SRE & Cluster Monitoring Dashboard
> Real-time Google SRE Golden Signals (Available Replicas, Restarts, CPU Cores, Memory Working Set) and EC2 Host-level USE metrics (Node CPU, RAM, Disk).
![Grafana Cluster Overview Dashboard](./assets/devops/grafana_dashboard.png)

---

## 🛠️ The 10 DevOps Tools Breakdown

### 1. Git & GitHub (Source Code Management & Versioning)
* **Role:** Version control, collaborative Git workflow, and pipeline triggers.
* **Automation:** Webhook configured on `push` event pointing to `http://<JENKINS_IP>:8080/github-webhook/`.
* **Repository:** `https://github.com/Swarajbabu/Wanderlust-A-DevOps-Integrated-Travel-Booking-Platform`

### 2. Docker (Containerization)
* **Base Image:** `node:20-alpine` (lightweight, minimal attack surface, fast cold-starts).
* **Optimization:** Layer-cached dependencies (`npm ci --omit=dev --legacy-peer-deps`), explicit `.dockerignore` excluding logs, node_modules, and terraform states.
* **Exposed Port:** `8081` (standardized application port).

### 3. Docker Compose (Local Orchestration)
* Multi-container composition defining local environment parity with production.
* Mounts environment secrets, volume bindings, and automatic restarts.

### 4. Terraform (Infrastructure as Code - IaC)
* **Provider:** AWS (`ap-south-1` Mumbai region).
* **State Management:** Declarative HCL state tracking all cloud assets.
* **Modules provisioned in [`terraform/`](./terraform/):**
  - **VPC & Networking (`vpc.tf`):** Dedicated VPC (`10.0.0.0/16`), 2 Public Subnets in separate AZs (`ap-south-1a`, `ap-south-1b`), Internet Gateway, Route Tables.
  - **Compute (`ec2.tf`):** Ubuntu 22.04 LTS `t3.micro` instance running Jenkins, automated SSH RSA key pair generation (`jenkins_key.pem`), and dedicated Security Groups (Ports 22, 8080, 80).
  - **Registry (`ecr.tf`):** Private AWS ECR repository (`wanderlust-app`) with 30-day untagged image lifecycle cleanup policies.
  - **Kubernetes Cluster (`eks.tf`):** Amazon EKS cluster v1.30 (`wanderlust-cluster`) with an autoscaling Managed Node Group (2x `t3.small` AL2023 EC2 instances) and granular IAM cluster/node roles.

### 5. AWS Cloud Infrastructure
* **VPC ID:** `vpc-0c151e84a2fe16e5e`
* **Subnets:** `subnet-0a202270a4bc7c8ae`, `subnet-01616824816d5d0d6`
* **ECR Registry:** `861809200696.dkr.ecr.ap-south-1.amazonaws.com/wanderlust-app`
* **EKS Cluster:** `wanderlust-cluster` (Kubernetes v1.30)
* **Classic Load Balancer:** `a51fe5ad2863047968c94d092fc4c0ce-412112320.ap-south-1.elb.amazonaws.com`

### 6. Jenkins CI/CD Pipeline
* **Type:** Declarative Pipeline written in [`Jenkinsfile`](./Jenkinsfile).
* **Stages:**
  1. `SCM Checkout`: Pulls latest code using Jenkins Git plugin.
  2. `Docker Build`: Builds image tagged with `${BUILD_NUMBER}` and `:latest`.
  3. `Push to Amazon ECR`: Authenticates via AWS Credentials Store (`aws-credentials`), performs Docker login, and pushes images.
  4. `Zero-Downtime Deploy to EKS`: Updates container image on EKS and verifies rollout using `kubectl rollout status`.

### 7. Kubernetes (Orchestration on AWS EKS)
All declarative manifests reside in [`k8s/`](./k8s/):
* **`deployment.yaml`:**
  - **Replicas:** 3 Pods distributed across worker nodes.
  - **Strategy:** `RollingUpdate` with `maxSurge: 1` and `maxUnavailable: 0` (Zero Downtime).
  - **Resources:** Requests: `100m CPU / 128Mi RAM`, Limits: `500m CPU / 512Mi RAM`.
  - **Probes:** HTTP `livenessProbe` and `readinessProbe` targeting `/listings` on port 8081.
* **`service.yaml`:**
  - Type: `LoadBalancer` (provisions AWS Classic Load Balancer).
  - Port mapping: External Port `80` ➔ Target Container Port `8081`.
* **`hpa.yaml`:**
  - Horizontal Pod Autoscaler targeting 70% CPU threshold, auto-scaling up to 10 pods during traffic surges.
* **`secret.yaml`:**
  - Kubernetes Secret securing MongoDB Atlas connection strings and session keys.

### 8. Prometheus (Metrics Collection)
* Deployed via **`kube-prometheus-stack`** Helm chart inside the `monitoring` namespace.
* Uses pull-model scraping every 15 seconds.
* Tracks node-level metrics via **Node Exporter DaemonSet** and container lifecycle via **kube-state-metrics**.

### 9. Grafana (Observability & SRE Dashboards)
* Live dashboard available at [`k8s/wanderlust-grafana-dashboard.json`](./k8s/wanderlust-grafana-dashboard.json).
* Built around the **Google SRE Golden Signals** and **Brendan Gregg's USE Method**:
  - **Healthy Replicas (Stat):** 3/3 target.
  - **Pod Restarts (Stat):** Tracks unexpected crashes, fatal errors, and `OOMKilled` events.
  - **Total App Memory (Stat):** Real RAM held across pods.
  - **Pod CPU Usage & Memory Working Set (Time Series):** Live cores and RAM per pod.
  - **Worker Node CPU, Memory & Disk (Gauges):** Prevents node resource exhaustion.
  - **Network I/O (Time Series):** Rx/Tx network bandwidth.

### 10. Helm (Kubernetes Package Management)
* Standardized deployment of complex multi-pod systems.
* Automated provisioning of Prometheus Operator CRDs, Grafana configs, Alertmanager, and exporters with a single command.

---

## ⚡ Quick Start & Deployment Guide

### Prerequisites
- AWS CLI v2 configured (`aws configure`)
- Terraform v1.5+
- Kubectl v1.30+
- Helm v3+
- Git

### 1. Provision Infrastructure via Terraform
```powershell
cd terraform
terraform init
terraform apply -auto-approve
```
*Outputs will display the Jenkins Public IP, ECR URL, and EKS Cluster name.*

### 2. Connect Kubectl to AWS EKS
```powershell
aws eks update-kubeconfig --region ap-south-1 --name wanderlust-cluster
kubectl get nodes
```

### 3. Deploy Application to Kubernetes
```powershell
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
```

### 4. Deploy Monitoring Stack via Helm
```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
```

### 5. Access Grafana Dashboard
```powershell
kubectl port-forward svc/prometheus-stack-grafana 3000:80 -n monitoring
```
1. Open [http://localhost:3000](http://localhost:3000)
2. Log in with Username: `admin` | Password: `prom-operator`
3. Go to **Dashboards** > **New** > **Import**, upload [`k8s/wanderlust-grafana-dashboard.json`](./k8s/wanderlust-grafana-dashboard.json), and click **Import**.

---

## 📊 Kubernetes Command Cheat Sheet for Evaluation

| Command | Purpose |
|---|---|
| `kubectl get pods -o wide` | List all pods, IPs, and worker node distribution |
| `kubectl get svc` | Display the live AWS Load Balancer external DNS URL |
| `kubectl scale deployment wanderlust-deployment --replicas=5` | Dynamically scale pods from 3 to 5 |
| `kubectl logs -l app=wanderlust --tail=50 -f` | Stream live application logs from all pods |
| `kubectl rollout status deployment/wanderlust-deployment` | Verify zero-downtime rolling update status |
| `kubectl rollout undo deployment/wanderlust-deployment` | Instantly rollback to the previous deployment build |
| `kubectl get nodes` | Check health and readiness of physical EC2 worker nodes |

---

## 🧹 Infrastructure Teardown (Cost Protection)

To avoid draining AWS Free Tier or promotional credits when testing is concluded:

```powershell
# 1. Delete Kubernetes resources to release the AWS Load Balancer
kubectl delete -f k8s/service.yaml
helm uninstall prometheus-stack -n monitoring
kubectl delete namespace monitoring

# 2. Destroy all AWS infrastructure via Terraform
cd terraform
terraform destroy -auto-approve
```

---

<div align="center">
<b>Developed with ❤️ for Production Cloud & DevOps Engineering Excellence</b>
</div>