# 🚀 Wanderlust DevOps Project - Teacher Demo & Viva Cheat Sheet

> **Project Name:** Wanderlust - DevOps Integrated Travel Booking Platform  
> **Tech Stack (10 Tools):** Git, GitHub, Docker, Docker Compose, AWS (VPC, EC2, ECR, EKS, ELB), Terraform, Jenkins, Kubernetes, Prometheus, Grafana.

---

## 📌 Quick Access Links & Portals

| What Teacher Asks | Where to Open / Command | Credentials / Notes |
|---|---|---|
| **"Show me the Live Website"** | [http://a51fe5ad2863047968c94d092fc4c0ce-412112320.ap-south-1.elb.amazonaws.com/listings](http://a51fe5ad2863047968c94d092fc4c0ce-412112320.ap-south-1.elb.amazonaws.com/listings) | Live AWS Classic Load Balancer routing to 3 EKS pods. |
| **"Show me the Jenkins CI/CD Pipeline"** | [http://3.110.81.86:8080/job/wanderlust-pipeline/](http://3.110.81.86:8080/job/wanderlust-pipeline/) | **User:** `admin`<br>**Password:** `admin123` |
| **"Open the Grafana Monitoring Dashboard"** | In PowerShell run:<br>`kubectl port-forward svc/prometheus-stack-grafana 3000:80 -n monitoring`<br>Then open: [http://localhost:3000](http://localhost:3000) | **User:** `admin`<br>**Password:** `prom-operator`<br>Dashboard: *Wanderlust App & EKS Cluster Overview* |
| **"Show me your GitHub Repository"** | [https://github.com/Swarajbabu/Wanderlust-A-DevOps-Integrated-Travel-Booking-Platform](https://github.com/Swarajbabu/Wanderlust-A-DevOps-Integrated-Travel-Booking-Platform) | Contains `Dockerfile`, `Jenkinsfile`, `k8s/`, `terraform/`. |
| **"Show me your Amazon ECR Images"** | AWS Console -> ECR -> `wanderlust-app` | Shows tagged images (`:1`, `:2` ... `:latest`). |

---

## 🧭 Live Demo Scenarios (What Teacher Will Ask & How to Respond)

### 1️⃣ Teacher asks: "Show me how your CI/CD Pipeline works"
1. Open [http://3.110.81.86:8080/job/wanderlust-pipeline/](http://3.110.81.86:8080/job/wanderlust-pipeline/).
2. Point out the **Stage View**:
   - `Checkout`: Pulls the latest commit from GitHub.
   - `Docker Build & Tag`: Builds image using Dockerfile and tags it with build number.
   - `Push to Amazon ECR`: Authenticates with AWS and pushes to private ECR repository.
   - `Deploy to EKS`: Executes `kubectl set image` for zero-downtime rolling update.
3. **If teacher says "Trigger a build right now":**
   - Click **"Build Now"** in the left sidebar, OR
   - Make a tiny change (e.g. edit README), `git commit -am "test trigger"`, and `git push origin main`. Show the GitHub webhook trigger building automatically!

---

### 2️⃣ Teacher asks: "How many pods are deployed and where are they running?"
Run this command in PowerShell:
```powershell
kubectl get pods -o wide
```
**What to explain:**
> *"We have 3 replicas running across 2 different worker nodes (`ip-10-0-1-81` and `ip-10-0-2-66`) in separate availability zones for High Availability (HA)."*

---

### 3️⃣ Teacher asks: "Scale the application up/down right now (Change Replicas)"
To scale from 3 pods to 5 pods live:
```powershell
kubectl scale deployment wanderlust-deployment --replicas=5
```
Verify immediately:
```powershell
kubectl get pods
```
To scale back down to 3:
```powershell
kubectl scale deployment wanderlust-deployment --replicas=3
```
**Teacher Viva Question:** *"Why not just edit the file?"*  
**Your Answer:** *"We can also change `replicas: 5` in `k8s/deployment.yaml` and run `kubectl apply -f k8s/deployment.yaml` for GitOps-compliant declarative scaling."*

---

### 4️⃣ Teacher asks: "Show me the logs of your application"
To stream real-time logs from any running pod:
```powershell
# Get pod name first
kubectl get pods

# View logs (replace with any active pod name)
kubectl logs -l app=wanderlust --tail=50 -f
```

---

### 5️⃣ Teacher asks: "How does Zero-Downtime Rolling Update work?"
Run this to see the rollout history:
```powershell
kubectl rollout history deployment/wanderlust-deployment
```
**Your Explanation:**
> *"In `k8s/deployment.yaml`, we configured a `RollingUpdate` strategy with `maxSurge: 1` and `maxUnavailable: 0`. When a new image is deployed, Kubernetes spins up a new pod and waits for its readiness probe (`/listings`) to pass before terminating the old pod. Users never see a 404 or connection drop."*

---

## 📊 Kubernetes Command Reference Table

Keep this table handy during your presentation:

| Task / Question | PowerShell Command | Explanation |
|---|---|---|
| **View all Pods** | `kubectl get pods` | Shows pod name, ready count, status, restart count. |
| **View Pods with IP & Node** | `kubectl get pods -o wide` | Shows which EC2 worker node each pod runs on. |
| **View Services & Load Balancer** | `kubectl get svc` | Shows the AWS ELB DNS URL and exposed ports (80:30944). |
| **View Deployment Details** | `kubectl get deployment` | Shows Desired, Current, Up-to-date, and Available replicas. |
| **Inspect a Pod in Detail** | `kubectl describe pod <pod-name>` | Shows container image, environment variables, events, and health probes. |
| **Change Pod Replicas** | `kubectl scale deployment wanderlust-deployment --replicas=<N>` | Dynamically scales the pods up or down. |
| **Check Rollout Status** | `kubectl rollout status deployment/wanderlust-deployment` | Verifies if deployment is successfully rolling out. |
| **Rollback a Bad Deployment** | `kubectl rollout undo deployment/wanderlust-deployment` | Instantly rolls back to the previous working image. |
| **View Worker Nodes** | `kubectl get nodes` | Shows the 2 AWS EC2 worker instances and their status (`Ready`). |
| **View Monitoring Pods** | `kubectl get pods -n monitoring` | Shows Prometheus Operator, Grafana, and Node Exporters. |
| **Tunnel to Grafana** | `kubectl port-forward svc/prometheus-stack-grafana 3000:80 -n monitoring` | Opens port `3000` locally to access Grafana web UI. |

---

## 📈 Grafana Monitoring & Metrics Viva Guide

When opening **Grafana** at `http://localhost:3000`:

1. **Top Row - Application Health:**
   - **Healthy Replicas (3):** Proves the desired state matches the current state.
   - **Pod Restarts (0):** Confirms zero crashes, zero uncaught exceptions, and no `OOMKilled` (Out Of Memory) events.
   - **Total App Memory (~205 MiB):** Real physical memory consumed by Node.js.
   - **Cluster Ready Nodes (2):** Shows both EC2 instances are healthy.

2. **Middle Row - Pod Compute Resources:**
   - **Pod CPU Usage (Cores):** Shows millicores used per container against the `500m` limit.
   - **Pod Memory Usage (Working Set):** Live graph tracking RAM per pod against the `512Mi` limit.

3. **Bottom Row - Worker Nodes (USE Method):**
   - **Node CPU Utilization (~4-5%):** Compute capacity used on EC2 instances.
   - **Node Memory Utilization (~38% & 84%):** Memory saturation across worker nodes.
   - **Node Disk Space Used (~19% & 28%):** Root EBS volume disk capacity.

---

## ⚠️ Safe Cleanup (After Teacher Evaluates the Project)

To avoid consuming extra AWS credits:

```powershell
# 1. Delete the Kubernetes LoadBalancer & Monitoring (releases the AWS ELB)
kubectl delete -f .\k8s\service.yaml
helm uninstall prometheus-stack -n monitoring
kubectl delete namespace monitoring

# 2. Destroy all AWS Infrastructure via Terraform
cd terraform
terraform destroy -auto-approve
```
