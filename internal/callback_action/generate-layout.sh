#!/bin/bash
set -euo pipefail

artifact="${ARTIFACT}"

hash=$(sha256sum "$artifact" | awk '{print $1}')
subject_name=$(basename "$(readlink -m "$artifact")")
printf -v subjects \
    '{"name": "%s", "digest": {"sha256": "%s"}}' \
    "$subject_name" "$hash"

cat <<EOF >DATA
{
    "version": 1,
    "attestations":
    [
        {
            "name": "${artifact}",
            "subjects":
            [
                ${subjects}
            ]
        }
    ]
}
EOF

jq <DATA

# Expected file with pre-defined output
cat DATA > "$SLSA_OUTPUTS_ARTIFACTS_FILE"