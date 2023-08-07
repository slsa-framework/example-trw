#!/bin/bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "missing argument"
    echo "usage: $0 <tag>"
    exit 1
fi

builder_tag="$1"

echo "Updating tag $builder_tag to main"

# Update refs for internal Actions to use main.
find high-perms/ high-perms-checkout/ low-perms/ \
    -name '*.yaml' -o -name '*.yml' -type f -print0 | \
    xargs -0 sed -i "s/uses: slsa-framework\/slsa-github-generator\/\(.*\)@${builder_tag}/uses: slsa-framework\/slsa-github-generator\/\1@main/"

# Update the builders to use the delegator's main branch.
find .github/workflows/builder_high-perms-checkout_slsa3.yml \
    .github/workflows/builder_high-perms_slsa3.yml \
    .github/workflows/builder_low-perms_slsa3.yml \
    -name '*.yaml' -o -name '*.yml' -type f -print0 | \
    xargs -0 sed -i "s/uses: slsa-framework\/slsa-github-generator\/\(.*\)@${builder_tag}/uses: slsa-framework\/slsa-github-generator\/\1@main/"

# Update refs for builder tests to use the latest tag.
find .github/workflows/builder_high-perms-checkout_slsa3_test.yml \
    .github/workflows/builder_high-perms_slsa3_test.yml \
    .github/workflows/builder_low-perms_slsa3_test.yml \
    -name '*.yaml' -o -name '*.yml' -type f -print0 | \
    xargs -0 sed -i "s/uses: slsa-framework\/example-trw\/\(.*\)@${builder_tag}/uses: slsa-framework\/example-trw\/\1@main/"

echo "push those changes to the repo".


