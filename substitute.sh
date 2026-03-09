#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <templatefile> <outputfile> <env>" >&2
  exit 1
fi

templatefile="$1"
outputfile="$2"
env="$3"

templatePath="lib/$templatefile"
envFile="clusters/$env/.env"
outputPath="clusters/$env/$outputfile"
outputDirectory="$(dirname "$outputPath")"

if [[ ! -f "$templatePath" ]]; then
  echo "Template file not found: $templatePath" >&2
  exit 1
fi

if [[ ! -f "$envFile" ]]; then
  echo "Environment file not found: $envFile" >&2
  exit 1
fi

mkdir -p "$outputDirectory"

template="$(cat "$templatePath")"

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

while IFS= read -r line || [[ -n "$line" ]]; do
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ "$line" =~ ^[[:space:]]*$ ]] && continue
  [[ "$line" != *"="* ]] && continue

  key="${line%%=*}"
  value="${line#*=}"

  key="$(trim "$key")"
  value="$(trim "$value")"

  placeholder="\${$key}"
  template="${template//${placeholder}/${value}}"
done < "$envFile"

printf '%s' "$template" > "$outputPath"
