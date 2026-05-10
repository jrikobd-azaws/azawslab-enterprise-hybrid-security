#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

KV_NAME="${KV_NAME:-kvdevazawsne01}"
WINDOWS_LOCAL_ADMIN_SECRET_NAME="${WINDOWS_LOCAL_ADMIN_SECRET_NAME:-local-admin-password}"
HQ_DOMAIN_JOIN_SECRET_NAME="${HQ_DOMAIN_JOIN_SECRET_NAME:-hq-domain-join-password}"

# Force this run to use the VM managed identity, not any cached user login.
az account clear
az login --identity --allow-no-subscriptions >/dev/null

export WINDOWS_LOCAL_ADMIN_PASSWORD="$(
  az keyvault secret show \
    --vault-name "$KV_NAME" \
    --name "$WINDOWS_LOCAL_ADMIN_SECRET_NAME" \
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
  unset WINDOWS_LOCAL_ADMIN_PASSWORD || true
  unset HQ_DOMAIN_JOIN_PASSWORD || true
}
trap cleanup EXIT

if [ -z "${WINDOWS_LOCAL_ADMIN_PASSWORD:-}" ]; then
  echo "WINDOWS_LOCAL_ADMIN_PASSWORD was not loaded from Key Vault."
  exit 1
fi

if [ -z "${HQ_DOMAIN_JOIN_PASSWORD:-}" ]; then
  echo "HQ_DOMAIN_JOIN_PASSWORD was not loaded from Key Vault."
  exit 1
fi

echo "Runtime secrets loaded from Key Vault using vm-dev-mgmt-01 managed identity."
echo "Secret values will not be printed."

cd "$HOME/release2-ansible"

if [ "$#" -gt 0 ]; then
  "$@"
else
  ansible-playbook \
    -i "$HOME/release2-ansible/inventory/dev/hosts.ini" \
    "$HOME/release2-ansible/site.yml"
fi
