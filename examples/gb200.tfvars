# GB200 SLURM Cluster Configuration Example
# This configuration has been tested and validated with GB200 instances

# Common configuration
location = "eu-iceland1-a"
project_id = "your-project-id-here"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"
vpc_subnet_id = "your-vpc-subnet-id-here"

# Head and login nodes
slurm_head_node_count = 1
slurm_login_node_count = 1

# GB200 compute node configuration
slurm_compute_node_type = "gb200-186gb-nvl-ib.4x"
slurm_compute_node_count = 2

# InfiniBand partition ID (required for GB200)
# Get this from your Crusoe Cloud console or contact your admin
slurm_compute_node_ib_partition_id = "your-ib-partition-id-here"

# GB200 requires IMEX support
enable_imex_support = true

# Observability (Prometheus + Grafana)
enable_observability = true
grafana_admin_password = "change-me-to-secure-password"

# Shared storage configuration
# These sizes have been tested and work well for small-medium clusters
slurm_shared_disk_nfs_home_size = "1024GiB"
slurm_data_disk_size = "1024GiB"
slurm_data_disk_mount_path = "/data"

# SLURM users configuration
# Add your users here with their SSH public keys
slurm_users = []

# Example with users:
# slurm_users = [{
#   name = "user1"
#   uid = 1001
#   ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user1@example.com"
# }, {
#   name = "user2"
#   uid = 1002
#   ssh_pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user2@example.com"
# }]

# Notes:
# - GB200 instances use ARM64 architecture (Grace-Blackwell)
# - CPU topology: 128 CPUs = 2 sockets × 32 cores × 2 threads per node
# - Memory: ~186GB per node
# - GPUs: 4x NVIDIA GB200 per node
# - InfiniBand support required for optimal performance
# - VAST NFS migration must be completed before deployment (see docs/VAST_NFS_MIGRATION.md)
