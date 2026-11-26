#!/bin/sh

# Recreate the Firebase configuration that is intentionally excluded from Git.
# In Xcode Cloud, define GOOGLE_SERVICE_INFO_PLIST_BASE64 as a secret
# environment variable containing the base64-encoded GoogleService-Info.plist.
set -eu

if [ -z "${GOOGLE_SERVICE_INFO_PLIST_BASE64:-}" ]; then
    echo "error: GOOGLE_SERVICE_INFO_PLIST_BASE64 is not configured."
    exit 1
fi

repository_path="${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"
destination="${repository_path}/LightMeter/GoogleService-Info.plist"

mkdir -p "$(dirname "${destination}")"
printf '%s' "${GOOGLE_SERVICE_INFO_PLIST_BASE64}" | base64 -D > "${destination}"

if ! plutil -lint "${destination}" >/dev/null; then
    echo "error: Decoded GoogleService-Info.plist is invalid."
    exit 1
fi

echo "Firebase configuration restored for Xcode Cloud."
