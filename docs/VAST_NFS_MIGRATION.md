# VAST NFS Migration Guide

## Overview

VAST NFS is Crusoe's network file system that provides shared storage for SLURM clusters. Before deploying a SLURM cluster in a new project, the project must be migrated to use VAST NFS networking (100.64.0.0/16 network).

**Important:** This is a **one-time, project-level operation**. Once completed, all future VM deployments in the project will automatically have access to VAST NFS.

## When to Perform Migration

You need to perform VAST NFS migration if:
- ✅ This is a **new project** that has never had SLURM clusters deployed
- ✅ You get network unreachability errors when pinging `100.64.0.2`
- ✅ NFS mounts fail during Terraform/Ansible deployment

You do **NOT** need to perform migration if:
- ❌ The project has already been migrated (migration persists across cluster destroy/recreate)
- ❌ Existing clusters in the project are already using VAST NFS
- ❌ You can successfully ping `100.64.0.2` from VMs in the project

## Prerequisites

- Access to `cloud-admin` CLI tool
- Project ID (found in `terraform.tfvars` or Crusoe Cloud console)
- Appropriate permissions to perform project-level operations

## Migration Steps

### 1. Set Your Project ID

```bash
export PROJID="your-project-id-here"
```

Example:
```bash
export PROJID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

### 2. Add Project to Migration Table

```bash
cloud-admin nfs add-to-migration-table --project-id $PROJID
```

This registers the project for VAST NFS migration.

### 3. Enable NFS for the Project

```bash
cloud-admin nfs enable-nfs --project-id $PROJID
```

This enables VAST NFS networking for the project.

### 4. Complete the Migration

```bash
cloud-admin nfs complete-migration --project-id $PROJID
```

**Note:** This command may prompt for confirmation. Follow the interactive prompts to complete the migration.

### 5. Clean Up Legacy virtiofs

```bash
cloud-admin nfs virtiofs-cleanup --project-id $PROJID
```

This removes legacy virtiofs components and finalizes the migration.

## Verification

After completing the migration, verify VAST NFS connectivity:

```bash
# SSH into any VM in the project
ssh ubuntu@<vm-ip>

# Ping the VAST NFS gateway
ping -c 4 100.64.0.2
```

Expected output:
```
PING 100.64.0.2 (100.64.0.2) 56(84) bytes of data.
64 bytes from 100.64.0.2: icmp_seq=1 ttl=64 time=0.123 ms
64 bytes from 100.64.0.2: icmp_seq=2 ttl=64 time=0.098 ms
64 bytes from 100.64.0.2: icmp_seq=3 ttl=64 time=0.101 ms
64 bytes from 100.64.0.2: icmp_seq=4 ttl=64 time=0.105 ms
```

## Troubleshooting

### Issue: "Project not found" or permission errors
**Solution:** Verify you have the correct project ID and appropriate cloud-admin permissions.

### Issue: Migration appears to hang
**Solution:** The `complete-migration` step may require manual confirmation. Check for interactive prompts.

### Issue: 100.64.0.2 still unreachable after migration
**Solution:**
1. Verify all migration steps completed successfully
2. Try destroying and recreating VMs in the project
3. Contact Crusoe support if issue persists

## Additional Notes

- **Persistence:** Migration changes are permanent at the project level
- **Cluster Lifecycle:** You can destroy and recreate clusters without repeating migration
- **Multiple Clusters:** All clusters in a migrated project automatically get VAST NFS access
- **Network Range:** VAST NFS uses 100.64.0.0/16 address space
- **Impact:** No impact on existing cluster functionality; only enables new NFS capabilities

## Related Documentation

- [Crusoe VAST NFS Documentation](https://docs.crusoecloud.com/) (if available)
- [SLURM Cluster Deployment Guide](../README.md)
- Main repository README for general cluster setup

## Questions?

For questions about VAST NFS migration, contact:
- Crusoe DevX team
- Your onboarding mentor
- Crusoe Cloud support
