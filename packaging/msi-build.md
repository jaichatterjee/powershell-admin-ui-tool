# MSI Packaging Overview

This document describes how the PowerShell Administrative UI Tool
is packaged into an MSI-grade application for enterprise deployment.

## Packaging Approach
- Source scripts staged into application directory
- Install.ps1 handles initial setup
- Run.ps1 executes the UI tool
- Uninstall.ps1 performs clean removal
- Versioning controlled via metadata file

## Supported Platforms
- Microsoft Intune (Win32 App)
- SCCM / MECM

## What Is Not Included
- MSI binaries
- Tenant-specific configuration
- Signing certificates

This documentation exists to demonstrate **deployment readiness**, not distribution.

