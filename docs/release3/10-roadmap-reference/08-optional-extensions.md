# 04. Observability & Resilience Direction

> **Part of** [Release 3 - Multi-Cloud Kubernetes, GitOps & DevSecOps](./README.md)
>
> **Status:** Roadmap / platform evolution

## Purpose

Define the observability stack and resilience validation strategy for the multi-cloud Kubernetes fleet.

## Direction Overview

- **Metrics:** Prometheus will be the primary metrics collection engine, with managed Prometheus instances on AKS and a self-managed or managed equivalent on EKS. Grafana will provide unified dashboards across clouds.
- **Logging:** Loki (or equivalent) will aggregate container and application logs, integrated with the existing Azure Log Analytics workspace where useful.
- **Tracing:** OpenTelemetry will be used for distributed tracing across services, with sampling and export to the observability platform.
- **Alerting:** Prometheus alert rules and Grafana alerting will feed into the existing Azure Monitor action groups and notification channels.
- **Resilience validation:**
  - Pod disruption budgets (PDBs) will be defined for all production workloads.
  - Multi-zone node pools will be the default.
  - Chaos engineering experiments (planned, controlled) will validate failover, network partition recovery, and node loss scenarios.
- **Disaster recovery alignment:** The existing Recovery Services Vault and immutability patterns from Release 2 will be extended to cover Kubernetes state (etcd snapshots, persistent volume backups).

## Relationship to Release 2

- The managed Prometheus/Grafana integration on AKS (O4) provides a proven observability baseline.
- The Azure Monitor alerting pipeline (P9a) is already validated and can ingest new alert sources.
- The backup immutability and MUA model (P9b) provides a template for Kubernetes backup governance.
- The staged redesign approach (P9b-redesign) will guide iterative resilience testing.

> Current visual reference: [Release 3 roadmap target state](../../../diagrams/release3/release3-target-roadmap.png).