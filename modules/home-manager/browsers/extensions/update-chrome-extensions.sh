#!/usr/bin/env bash

# This script fetches the latest CRX files for your Chromium extensions,
# computes their hashes, and writes them to hashes.json for Nix.

cd "$(dirname "$0")" || exit 1

# Read all chromeId fields from the nix files in this directory
IDS=$(grep -h -oP 'chromeId\s*=\s*"\K[^"]+' ./*.nix | sort -u)

echo "{" >hashes.json

FIRST=true

for id in $IDS; do
	echo "Fetching $id..."
	URL="https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=113.0&x=id%3D${id}%26installsource%3Dondemand%26uc"

	HASH=$(nix-prefetch-url "$URL" 2>/dev/null)

	if [ -n "$HASH" ]; then
		if [ "$FIRST" = true ]; then
			FIRST=false
		else
			echo "  ," >>hashes.json
		fi
		{
			echo "  \"$id\": {"
			echo "    \"hash\": \"$HASH\","
			echo "    \"url\": \"$URL\""
			echo "  }"
		} >>hashes.json
	else
		echo "Failed to fetch $id"
	fi
done

echo "}" >>hashes.json
echo "Done!"
