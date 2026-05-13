#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

cd "$(dirname "$0")/.."

set +x
source scripts/load-runtime-secrets.sh

mkdir -p "$HOME/azawslab-o3b-ansible/evidence/a1-ansible-network-baseline"

ansible-playbook \
  -i inventories/dev.yml \
  playbooks/idempotency-check.yml

unset FORTIOS_ACCESS_TOKEN
unset O3B_VYOS_ANSIBLE_PASSWORD
unset O3B_CISCO_RESTCONF_PASSWORD

echo "A1 idempotency/no-change check complete. Runtime secrets unset."