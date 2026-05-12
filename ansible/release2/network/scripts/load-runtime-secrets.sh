#!/usr/bin/env bash
set -euo pipefail

# A1 runtime secret loader.
# This script must be sourced by wrapper scripts.
# No secret values are written to disk.

: "${A1_AZURE_KEYVAULT_NAME:=kvdevazawsne01}"
: "${A1_FORTIGATE_TOKEN_SECRET_NAME:=p5-fortigate-api-token}"
: "${A1_VYOS_PASSWORD_SECRET_NAME:=o3b-vyos-ansible-password}"
: "${A1_AWS_REGION:=eu-west-1}"
: "${A1_AWS_PROFILE:=}"
: "${A1_CISCO_RESTCONF_PASSWORD_PARAMETER:=/azawslab/release2/o3b/cisco-restconf-password}"

if ! command -v az >/dev/null 2>&1; then
  echo "ERROR: Azure CLI is not installed or not in PATH." >&2
  return 1 2>/dev/null || exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI is not installed or not in PATH." >&2
  return 1 2>/dev/null || exit 1
fi

echo "Loading FortiGate API token from Azure Key Vault: ${A1_AZURE_KEYVAULT_NAME}/${A1_FORTIGATE_TOKEN_SECRET_NAME}" >&2
export FORTIOS_ACCESS_TOKEN="$(
  az keyvault secret show \
    --vault-name "$A1_AZURE_KEYVAULT_NAME" \
    --name "$A1_FORTIGATE_TOKEN_SECRET_NAME" \
    --query value \
    -o tsv
)"

echo "Loading VyOS Ansible password from Azure Key Vault: ${A1_AZURE_KEYVAULT_NAME}/${A1_VYOS_PASSWORD_SECRET_NAME}" >&2
export O3B_VYOS_ANSIBLE_PASSWORD="$(
  az keyvault secret show \
    --vault-name "$A1_AZURE_KEYVAULT_NAME" \
    --name "$A1_VYOS_PASSWORD_SECRET_NAME" \
    --query value \
    -o tsv
)"

if [ -n "$A1_AWS_PROFILE" ]; then
  echo "Using AWS profile for SSM: ${A1_AWS_PROFILE}" >&2
  export AWS_PROFILE="$A1_AWS_PROFILE"
fi

echo "Validating AWS identity before Cisco SSM read." >&2
aws sts get-caller-identity \
  --region "$A1_AWS_REGION" \
  --output text >/dev/null

echo "Loading Cisco RESTCONF password from AWS SSM: ${A1_CISCO_RESTCONF_PASSWORD_PARAMETER}" >&2
export O3B_CISCO_RESTCONF_PASSWORD="$(
  aws ssm get-parameter \
    --region "$A1_AWS_REGION" \
    --name "$A1_CISCO_RESTCONF_PASSWORD_PARAMETER" \
    --with-decryption \
    --query 'Parameter.Value' \
    --output text
)"

if [ -z "${FORTIOS_ACCESS_TOKEN}" ]; then
  echo "ERROR: FORTIOS_ACCESS_TOKEN is empty." >&2
  return 1 2>/dev/null || exit 1
fi

if [ -z "${O3B_VYOS_ANSIBLE_PASSWORD}" ]; then
  echo "ERROR: O3B_VYOS_ANSIBLE_PASSWORD is empty." >&2
  return 1 2>/dev/null || exit 1
fi

if [ -z "${O3B_CISCO_RESTCONF_PASSWORD}" ]; then
  echo "ERROR: O3B_CISCO_RESTCONF_PASSWORD is empty." >&2
  return 1 2>/dev/null || exit 1
fi

echo "A1 runtime secrets loaded into environment variables only." >&2