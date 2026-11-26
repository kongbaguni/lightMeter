#!/bin/sh

# Recreate the Firebase configuration that is intentionally excluded from Git.
# In Xcode Cloud, define GOOGLE_SERVICE_INFO_PLIST_BASE64 as a secret
# environment variable containing the base64-encoded GoogleService-Info.plist.
set -eu

if [ -z "${GOOGLE_SERVICE_INFO_PLIST_BASE64:-}" ]; then
    echo "error: The Xcode Cloud workflow is missing the GOOGLE_SERVICE_INFO_PLIST_BASE64 secret environment variable."
    echo "error: Add it to the workflow and assign the base64-encoded contents of GoogleService-Info.plist."
    exit 1
fi

repository_path="${CI_PRIMARY_REPOSITORY_PATH:-$(pwd)}"
destination="${repository_path}/LightMeter/GoogleService-Info.plist"

if [ ! -d "${repository_path}" ]; then
    echo "error: Xcode Cloud repository path does not exist: ${repository_path}"
    exit 1
fi

mkdir -p "$(dirname "${destination}")"
if ! printf '%s' "${GOOGLE_SERVICE_INFO_PLIST_BASE64}" | base64 -D > "${destination}"; then
    echo "error: GOOGLE_SERVICE_INFO_PLIST_BASE64 is not valid base64 data."
    exit 1
fi

if ! plutil -lint "${destination}" >/dev/null; then
    echo "error: Decoded GoogleService-Info.plist is invalid."
    exit 1
fi

echo "Firebase configuration restored for Xcode Cloud."
