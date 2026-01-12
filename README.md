# PowerShell Administrative UI Tool

## Overview
This repository contains a **PowerShell-based Administrative UI Tool** designed for enterprise environments.  
The solution has evolved from a script-based utility into a **deployment-grade application** suitable for **Microsoft Intune and SCCM (MECM)** delivery.

The focus of this repository is on **source code, application lifecycle design, and deployment strategy**, not binary distribution.

---

## Key Capabilities

### 🔹 Administrative UI (PowerShell)
- Menu-driven / UI-based administrative operations
- Designed for IT administrators and support teams
- Modular and maintainable structure

### 🔹 Enterprise Application Lifecycle
- Dedicated install, run, and uninstall scripts
- Clear separation of responsibilities
- Version-controlled application metadata

### 🔹 MSI-Grade Deployment Readiness
- Packaged and validated as an **MSI-grade application**
- Suitable for:
  - Microsoft Intune (Win32 app)
  - Microsoft SCCM / MECM
- Supports silent install and uninstall
- Designed for upgrade and detection logic

> **Note:**  
> The MSI binary is intentionally **not published** in this repository.  
> This repo demonstrates **how the application is built and deployed**, not how binaries are distributed.

---

```text
powershell-admin-ui-tool/
│
├── README.md
├── .gitignore
│
├── src/
│ ├── App/
│ │ ├── Main.ps1
│ │ ├── Assets/
│ │ └── Modules/
│ │
│ ├── Install.ps1
│ ├── Run.ps1
│ └── Uninstall.ps1
│
├── packaging/
│ ├── msi-build.md
│ └── detection-rules.md
│
├── docs/
│ ├── screenshots.md
│ └── lifecycle.md
│
└── examples/
└── sample-config.json
```

---

## How the Application Works

### Install Phase
- Application files are staged to the target system
- Prerequisites are validated
- Version metadata is registered

### Run Phase
- UI is launched via `Run.ps1`
- Administrator interacts with the tool
- Operational logic executes within the UI layer

### Uninstall Phase
- Application files and configuration are removed
- System is returned to a clean state

---

## Enterprise Deployment (Intune / SCCM)

This application has been validated for enterprise deployment using:

- **Microsoft Intune (Win32 application)**
- **Microsoft SCCM / MECM**

### Deployment Characteristics
- Silent installation support
- Silent uninstallation support
- Version-aware upgrades
- Detection rule compatibility
- No hardcoded tenant or environment data

Detailed deployment documentation is available under:

---

## Configuration
Configuration and versioning are handled separately from code logic to support:

- Safe upgrades
- Environment neutrality
- Predictable deployments

Example configuration files are provided under:

---

## Security & Design Principles
- No credentials stored in the repository
- No tenant IDs or environment-specific secrets
- No MSI or executable binaries published
- Source-first, documentation-driven approach
- Designed for auditability and maintainability

---

## Intended Audience
- IT Support Engineers
- Endpoint / Intune Administrators
- Automation Engineers
- Enterprise IT Operations teams

---

> ## Disclaimer
This project is shared for **demonstration and portfolio purposes only**.  
All examples are sanitized.  
Use in production environments should follow organizational security, packaging, and change-management policies.

---

> ## Author
PowerShell automation with a focus on **enterprise tooling, endpoint deployment, and administrative UX design**.


