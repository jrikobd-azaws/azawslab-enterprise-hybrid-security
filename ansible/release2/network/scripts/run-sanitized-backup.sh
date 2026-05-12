#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

set +x
source scripts/load-runtime-secrets.sh

mkdir -p "$HOME/azawslab-o3b-ansible/evidence/a1-ansible-network-baseline"
mkdir -p "$HOME/azawslab-o3b-ansible/backups/sanitized"

ansible-playbook \
  -i inventories/dev.yml \
  playbooks/sanitized-backup.yml

unset FORTIOS_ACCESS_TOKEN
unset O3B_VYOS_ANSIBLE_PASSWORD
unset O3B_CISCO_RESTCONF_PASSWORD

echo "A1 sanitized backup complete. Runtime secrets unset."