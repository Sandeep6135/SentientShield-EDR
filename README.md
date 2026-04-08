# Project 2: SOC - Endpoint Detection & Response Grid
**Product Brand Name:** Sentient Shield  
**Domain:** EDR & Threat Detection

## Overview
Sentient Shield is a centralized, real-time EDR grid built on Wazuh. It provides granular visibility into endpoint activities, maps adversary tactics to the **MITRE ATT&CK** framework, and executes automated remediation to neutralize threats at the source.

## Key Features
* [cite_start]**File Integrity Monitoring (FIM):** Instant alerting on modifications to critical system files like `/etc/passwd`[cite: 63, 69].
* [cite_start]**Active Response:** Automated IP banning via host firewalls after 5 failed login attempts[cite: 70].
* [cite_start]**MITRE ATT&CK Mapping:** All custom rules are enriched with MITRE technique IDs (e.g., T1490 for ransomware)[cite: 71, 77].

## Threat Simulation (Week 4)
Using the **Atomic Red Team** framework, we simulate ransomware patterns:
1. **Execution:** Deleting Shadow Volume Copies (`vssadmin delete shadows`).
2. **Detection:** Wazuh rule `100002` triggers a Level 15 alert.
3. **Response:** The system triggers an automated isolation of the host.