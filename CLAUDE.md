# trivy-githubaction

Test repository demonstrating Trivy GitHub Actions scanning across multiple target types.
All vulnerabilities and misconfigurations are **intentional** — this repo is a scan demo, not a real deployment.

## What's here

| File/Dir | Trivy scan type | What it catches |
|---|---|---|
| `Dockerfile` + `requirements.txt` | image / fs | OS CVEs in old `python:3.8.0` base; known-vuln Python packages |
| `app.py` | fs (secrets) | Hardcoded AWS keys, GitHub token, Stripe key, DB URL, SendGrid key |
| `terraform/main.tf` | config (IaC) | Public S3, open security groups, unencrypted RDS, wildcard IAM, no IMDSv2 |
| `kubernetes/deployment.yaml` | config (IaC) | Privileged container, hardcoded env secrets, no resource limits, hostPID/IPC |
| `kubernetes/rbac.yaml` | config (IaC) | Wildcard ClusterRole (full cluster access) |
| `kubernetes/network-policy.yaml` | config (IaC) | Permissive PodSecurityPolicy |

## GitHub Actions workflow

`.github/workflows/trivy-scan.yml` runs three jobs:

1. **trivy-fs-scan** — `scan-type: fs` with `vuln,secret,misconfig` scanners across the whole repo
2. **trivy-image-scan** — builds the Dockerfile then scans with `scan-type: image`
3. **trivy-iac-scan** — `scan-type: config` separately targeting `terraform/` and `kubernetes/`

All jobs upload SARIF to the **GitHub Security tab** (Code Scanning Alerts) and also print a table to the Actions log.

## Setup

1. Push this repo to GitHub (public or private)
2. Enable **GitHub Advanced Security** (free for public repos) to see Code Scanning Alerts
3. The workflow triggers on push, PR, and daily schedule
4. Results appear under **Security → Code scanning** in the GitHub UI
