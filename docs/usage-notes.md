# Usage Notes – PowerShell Administrative UI Tool

## Purpose
This document provides **operational guidance** for running the PowerShell Administrative UI Tool in a controlled environment.

The tool is designed for **interactive use** by IT support and operations teams and should be executed only by users with appropriate permissions for the tasks exposed through the UI.

---

## Intended Usage
- Interactive, menu-driven execution
- Administrative or operational support tasks
- Internal tooling for repeatable actions
- Delegation to L2 / L3 support teams where appropriate

The script is **not intended** for unattended, scheduled, or background execution.

---

## Execution Environment
- Windows PowerShell 5.1 or PowerShell 7.x
- Windows operating system with standard UI components
- Script execution policy allowing local script execution
- Network connectivity as required by the underlying administrative tasks

---

## How to Run
1. Open PowerShell
2. Navigate to the repository root
3. Execute the script:

```powershell
.\src\E2C_UI.ps1
