#!/usr/bin/env bash
# Checks the entries of _data/collection-index.yml that were added or changed compared to the given git ref:
# required properties are present, and ghcr.io collections have an ownerId matching the owner's GitHub account ID.
# Usage: check-collection-index.sh <base-ref>
set -euo pipefail

INDEX=_data/collection-index.yml
BASE_REF=${1:?Usage: $0 <base-ref>}
ERRORS=0

error() {
    echo "::error file=$INDEX::$1"
    ERRORS=$((ERRORS + 1))
}

# Prints the numeric ID of a GitHub account, nothing if it doesn't exist, and fails on other errors.
github_user_id() {
    local login=$1 resp status=403
    resp=$(mktemp)
    fetch() { curl -sS -o "$resp" -w '%{http_code}' -H 'Accept: application/vnd.github+json' "$@" "https://api.github.com/users/$login"; }
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        status=$(fetch -H "Authorization: Bearer $GITHUB_TOKEN")
    fi
    if [ "$status" = 403 ]; then
        # Organizations with an IP allow list reject the Actions token, even for public profile data.
        status=$(fetch)
    fi
    case $status in
        200) jq -r '.id' "$resp" ;;
        404) ;;
        *)
            echo "::error::Failed to look up GitHub account '$login': HTTP $status $(jq -r '.message // ""' "$resp" 2>/dev/null || true)" >&2
            return 1
            ;;
    esac
}

changed=$(jq -c -n \
    --argjson head "$(yq -o=json '.' "$INDEX")" \
    --argjson base "$(git show "$BASE_REF:$INDEX" | yq -o=json '.')" \
    '$head - $base | .[]')

count=0
while IFS= read -r entry; do
    [ -n "$entry" ] || continue
    count=$((count + 1))
    name=$(jq -r '.name // .ociReference // "<unnamed>"' <<<"$entry")

    for key in name maintainer contact repository ociReference; do
        if [ -z "$(jq -r --arg key "$key" '.[$key] // "" | tostring' <<<"$entry")" ]; then
            error "'$name': Missing '$key'."
        fi
    done

    oci=$(jq -r '.ociReference // ""' <<<"$entry")
    if [[ "$(tr '[:upper:]' '[:lower:]' <<<"$oci")" != ghcr.io/* ]]; then
        continue
    fi

    owner=$(cut -d/ -f2 <<<"$oci")
    owner_id=$(jq -r 'if (.ownerId | type) == "number" then .ownerId else "" end' <<<"$entry")
    if ! [[ "$owner" =~ ^[A-Za-z0-9-]+$ ]]; then
        error "'$name': '$oci' doesn't start with 'ghcr.io/<owner>/'."
    elif [ -z "$owner_id" ]; then
        error "'$name': Missing or non-numeric 'ownerId'. Set it to the numeric 'id' from https://api.github.com/users/$owner."
    else
        id=$(github_user_id "$owner")
        if [ -z "$id" ]; then
            error "'$name': GitHub account '$owner' not found."
        elif [ "$id" != "$owner_id" ]; then
            error "'$name': 'ownerId' is $owner_id, but GitHub account '$owner' has ID $id."
        fi
    fi
done <<<"$changed"

echo "Checked $count added or changed entries, found $ERRORS problems."
[ "$ERRORS" -eq 0 ]
