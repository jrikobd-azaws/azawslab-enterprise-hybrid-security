#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

KV_NAME="${KV_NAME:-kvdevazawsne01}"
LINUX_HQ_ADMIN_SECRET_NAME="${LINUX_HQ_ADMIN_SECRET_NAME:-hq-linux-admin-password}"
HQ_DOMAIN_JOIN_SECRET_NAME="${HQ_DOMAIN_JOIN_SECRET_NAME:-hq-svc-ansible-password}"

# Force this run to use the VM managed identity, not cached user credentials.
az account clear
az login --identity --allow-no-subscriptions >/dev/null

export LINUX_HQ_ADMIN_PASSWORD="$(
  az keyvault secret show \
    --vault-name "$KV_NAME" \
    --name "$LINUX_HQ_ADMIN_SECRET_NAME" \
    --query 'value' \
    --output tsv
)"

export HQ_DOMAIN_JOIN_PASSWORD="$(
  az keyvault secret show \
    --vault-name "$KV_NAME" \
    --name "$HQ_DOMAIN_JOIN_SECRET_NAME" \
    --query 'value' \
    --output tsv
)"

cleanup() {
  unset LINUX_HQ_ADMIN_PASSWORD || true
  unset HQ_DOMAIN_JOIN_PASSWORD || true
}
trap cleanup EXIT

if [ -z "${LINUX_HQ_ADMIN_PASSWORD:-}" ]; then
  echo "LINUX_HQ_ADMIN_PASSWORD was not loaded from Key Vault."
  exit 1
fi

if [ -z "${HQ_DOMAIN_JOIN_PASSWORD:-}" ]; then
  echo "HQ_DOMAIN_JOIN_PASSWORD was not loaded from Key Vault."
  exit 1
fi

echo "Runtime Linux and domain-join secrets loaded from Key Vault using vm-dev-mgmt-01 managed identity."
echo "Secret values will not be printed."

cd "$HOME/release2-ansible"

if [ "$#" -gt 0 ]; then
  "$@"
else
  ansible-playbook \
    -i "$HOME/release2-ansible/inventory/dev/hosts.ini" \
    "$HOME/release2-ansible/playbooks/linux-domain-join-hq.yml"
fi

