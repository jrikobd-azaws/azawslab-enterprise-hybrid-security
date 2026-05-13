#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

cd "$(dirname "$0")/.."

: "${A2_CHANGE_APPROVED:=false}"
: "${A2_CHANGE_TICKET:=}"
: "${A2_CHANGE_REASON:=}"

if [ "$A2_CHANGE_APPROVED" != "true" ]; then
  echo "ERROR: A2_CHANGE_APPROVED must be true for Tier 4 write." >&2
  exit 1
fi

if [ -z "$A2_CHANGE_TICKET" ]; then
  echo "ERROR: A2_CHANGE_TICKET is required for Tier 4 write." >&2
  exit 1
fi

if ! [[ "$A2_CHANGE_TICKET" =~ ^[A-Za-z0-9._:-]{3,64}$ ]]; then
  echo "ERROR: A2_CHANGE_TICKET must use only A-Z, a-z, 0-9, dot, underscore, colon, or dash." >&2
  exit 1
fi

if [ -z "$A2_CHANGE_REASON" ]; then
  echo "ERROR: A2_CHANGE_REASON is required for Tier 4 write." >&2
  exit 1
fi

set +x
source scripts/load-runtime-secrets.sh

mkdir -p "$HOME/azawslab-o3b-ansible/evidence/a1-ansible-network-baseline"
mkdir -p "$HOME/azawslab-o3b-ansible/backups/sanitized"

ansible-playbook \
  -i inventories/dev.yml \
  playbooks/sanitized-backup.yml \
  --limit vyos_routers

ansible-playbook \
  -i inventories/dev.yml \
  playbooks/vyos-marker-write.yml

unset FORTIOS_ACCESS_TOKEN
unset O3B_VYOS_ANSIBLE_PASSWORD
unset O3B_CISCO_RESTCONF_PASSWORD

echo "A2 VyOS marker write complete. Runtime secrets unset."