#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <env>" >&2
  exit 1
fi

env="$1"
scriptDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

"$scriptDir/substitute.sh" app-traefik-template.yaml applications/traefik.yaml "$env"
"$scriptDir/substitute.sh" app-external-dns-template.yaml applications/external-dns.yaml "$env"
"$scriptDir/substitute.sh" app-external-secrets-template.yaml applications/external-secrets.yaml "$env"
"$scriptDir/substitute.sh" app-reloader-template.yaml applications/reloader.yaml "$env"

"$scriptDir/substitute.sh" resources-external-dns-template.yaml external-dns/external-dns.yaml "$env"
"$scriptDir/substitute.sh" resources-external-secrets-template.yaml external-secrets/external-secrets.yaml "$env"

"$scriptDir/substitute.sh" secretfile-template.json secretfile.json "$env"
"$scriptDir/substitute.sh" argocd-values-template.yaml argocd-values.yaml "$env"
