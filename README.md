# SentientShield EDR

Enterprise-style Endpoint Detection and Response lab that simulates SOC-grade monitoring, detection engineering, and automated containment.

## Why This Project Exists

Modern attacks are fast, automated, and noisy at scale. Security teams need to detect early, enrich context quickly, and respond without waiting for manual triage.

SentientShield was designed as a practical EDR blueprint to:

- Continuously monitor Linux and Windows endpoints
- Detect abuse patterns such as brute force and ransomware behavior
- Map detections to MITRE ATT&CK techniques
- Trigger active response actions for rapid containment
- Visualize alerts centrally for SOC operations and incident analysis

## Core Capabilities

- Real-time file integrity monitoring (FIM) for sensitive directories
- Custom high-severity rules for identity file tampering and ransomware behavior
- Automatic firewall blocking through active response
- MITRE ATT&CK technique mapping in custom rules
- Dashboard-ready telemetry using Elasticsearch + Kibana
- Compliance-oriented security checks using custom CIS SCA policy

## Architecture At A Glance

```text
Endpoints (Linux/Windows + Wazuh Agent)
              |
              v
      Wazuh Manager (Rules + Correlation + Active Response)
              |
              v
      Elasticsearch (Alert/Event Storage)
              |
              v
      Kibana (Visibility + Investigation)
```

## Repository Layout

```text
SentientShield-EDR/
|- README.md
|- ARCHITECTURE.md
|- DEPLOYMENT_AND_TESTING.md
|- docker-compose.yml
|- scripts/
|  |- active-response.sh
|- wazuh-agent/
|  |- cis_debian_config.yml
|- wazuh-manager/
|  |- ossec.conf
|  |- local_rules.xml
```

## Detection Engineering Details

### Custom Rule: Identity File Tampering

- Rule ID: 100001
- Severity: 12 (critical)
- Trigger pattern: modification indicators for /etc/passwd or /etc/shadow
- MITRE mapping: T1078 (Valid Accounts)

### Custom Rule: Shadow Copy Deletion (Ransomware Pattern)

- Rule ID: 100002
- Severity: 15 (critical)
- Trigger pattern: vssadmin delete shadows
- MITRE mapping: T1490 (Inhibit System Recovery)

### Active Response Policy

Active response is configured to apply local firewall-drop behavior for selected rule IDs in the manager configuration.

- Command: firewall-drop
- Location: local
- Timeout: 3600 seconds
- Rules bound in config: 5712, 5720

## FIM Scope

The manager syscheck configuration includes:

- Real-time monitored directories: /etc, /usr/bin, /usr/sbin, /bin, /sbin
- Startup scan enabled
- New file alerting enabled
- Noise reduction excludes: /proc, /sys, /dev

This gives strong coverage on core system binaries and identity-critical files where attacker persistence often appears.

## Compliance And Hardening Signal

The custom CIS policy under wazuh-agent/cis_debian_config.yml includes checks such as:

- SSH root login disabled verification
- Secure permission validation for web directory path /var/www/html

This extends the project from pure detection into security posture and baseline control validation.

## Quick Start

### Prerequisites

- Docker and Docker Compose
- At least 4 GB RAM available for containers
- Admin/root privileges on test systems

### Launch Stack

```bash
docker-compose up -d
docker-compose ps
```

### Access Interfaces

- Kibana: http://localhost:5601
- Elasticsearch API: http://localhost:9200

## Test Scenarios

Use these scenarios to validate end-to-end telemetry and response:

1. FIM event generation
- Modify a monitored Linux file and confirm alert generation in Kibana.

2. SSH brute-force simulation
- Trigger repeated failed authentication attempts and observe rule matching plus response flow.

3. Ransomware behavior simulation
- Execute shadow copy deletion pattern in a Windows lab and verify Rule 100002 trigger and MITRE enrichment.

## Operations Runbook

Useful checks during operation:

```bash
docker-compose ps
docker-compose logs --tail=100 wazuh
docker-compose logs --tail=100 elasticsearch
docker-compose logs --tail=100 kibana
```

If alerts are missing, verify:

- Agent enrollment and connectivity
- Rule syntax and loading status
- Time synchronization across hosts
- Container health and resource limits

## Security Notes

- This repository contains demo credentials and lab-focused defaults.
- Rotate all credentials before any non-lab deployment.
- Enable strict TLS verification and production-grade secrets management for real environments.

## Known Deployment Caveat

In docker-compose.yml, both the Wazuh service and Elasticsearch declare host port 9200. Bind conflicts may occur depending on startup order and host state.

For stable local deployment, map one service to a different host port and update references accordingly.

## Roadmap Ideas

- Add SOAR playbooks for richer containment workflows
- Integrate threat intelligence feeds for context-aware scoring
- Add detection unit tests for custom rule regression checks
- Publish dashboard exports for one-command SOC visualization setup

## Author

Sandeep Hamirbhai Karmata

Cyber Security | SOC | Threat Hunting

Detect fast. Respond faster.