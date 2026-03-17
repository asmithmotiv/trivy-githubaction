# Trivy & Security Scanner Demo

> **⚠️: All credentials, secrets, and API keys in this repository are FAKE and intentionally planted for security scanner testing purposes. They will not work.**

This is a public demo repository for testing and comparing GitHub Actions-based security scanning tools. Every vulnerability, misconfiguration, and "secret" is deliberate — the goal is to see what each scanner finds and how results surface in the GitHub Security tab.

## Scanners configured

| Tool | Workflow | What it scans |
|---|---|---|
| [Trivy](https://github.com/aquasecurity/trivy) | `trivy-scan.yml` | Container image CVEs, filesystem vulns, secrets, IaC misconfigs |
| [Checkov](https://github.com/bridgecrewio/checkov) | `checkov.yml` | Terraform, Kubernetes, Dockerfile misconfigurations |
| [Semgrep](https://github.com/semgrep/semgrep) | `semgrep.yml` | Python SAST, secrets patterns, OWASP Top 10 |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | `gitleaks.yml` | Secrets in git history |
| [TruffleHog](https://github.com/trufflesecurity/trufflehog) | `trufflehog.yml` | Secrets in git history (with verification) |

## Intentional findings

### Fake secrets (`app.py`)
Hardcoded dummy credentials in the format of real secrets — used to test secret detection scanners. **None of these are valid.**

### Vulnerable Docker image (`Dockerfile`)
Uses `python:3.8.0` (EOL) as a base image, which contains a large number of known CVEs.

### Outdated Python packages (`requirements.txt`)
Pinned to old versions of Django, Flask, Pillow, cryptography, and others with published CVEs.

### Terraform misconfigurations (`terraform/main.tf`)
- S3 bucket with public read/write ACL and no encryption
- Security group open to `0.0.0.0/0` on all ports
- RDS instance that is publicly accessible, unencrypted, with no backups
- IAM policy with `Action: *` / `Resource: *`
- EC2 instance without IMDSv2 enforcement
- CloudTrail with log validation disabled

### Kubernetes misconfigurations (`kubernetes/`)
- Privileged container with `allowPrivilegeEscalation: true`
- `SYS_ADMIN` and `ALL` capabilities added
- `hostPID: true` and `hostIPC: true`
- Hardcoded secrets in environment variables
- No resource limits
- Wildcard `ClusterRole` granting full cluster access
- Permissive `PodSecurityPolicy`

## Viewing results

After a workflow run, findings appear under **Security → Code scanning alerts** in the GitHub UI. Each scanner uploads results in SARIF format, categorized separately so you can compare coverage side by side.
