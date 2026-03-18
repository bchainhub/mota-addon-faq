#!/usr/bin/env bash
set -euo pipefail

# Remove FAQ component files (paths relative to project root)
FAQ_BASE="src/lib/components/faq"
rm -f "${FAQ_BASE}/Faq.svelte"
rm -f "${FAQ_BASE}/index.ts"

# Remove empty dir
rmdir "${FAQ_BASE}" 2>/dev/null || true
