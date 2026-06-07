#!/usr/bin/env sh
set -eu

ENV_FILE="${1:-/datatools-config/env.yml}"
mkdir -p "$(dirname "$ENV_FILE")"

cat > "$ENV_FILE" <<EOF
AUTH0_CLIENT_ID: ${AUTH0_CLIENT_ID:-}
AUTH0_CONNECTION_NAME: ${AUTH0_CONNECTION_NAME:-}
AUTH0_DOMAIN: ${AUTH0_DOMAIN:-}
BUGSNAG_KEY: ${BUGSNAG_KEY:-}
MAPBOX_ACCESS_TOKEN: ${MAPBOX_ACCESS_TOKEN:-}
MAPBOX_MAP_ID: ${MAPBOX_MAP_ID:-mapbox/outdoors-v11}
MAPBOX_ATTRIBUTION: ${MAPBOX_ATTRIBUTION:-<a href="https://www.mapbox.com/about/maps/" target="_blank">&copy; Mapbox &copy; OpenStreetMap</a> <a href="https://www.mapbox.com/map-feedback/" target="_blank">Improve this map</a>}
MAP_BASE_URL: ${MAP_BASE_URL:-https://tile.openstreetmap.org/{z}/{x}/{y}.png}
SLACK_CHANNEL: ${SLACK_CHANNEL:-}
SLACK_WEBHOOK: ${SLACK_WEBHOOK:-}
GRAPH_HOPPER_KEY: ${GRAPH_HOPPER_KEY:-}
GRAPH_HOPPER_URL: ${GRAPH_HOPPER_URL:-}
GRAPH_HOPPER_POINT_LIMIT: ${GRAPH_HOPPER_POINT_LIMIT:-30}
GOOGLE_ANALYTICS_TRACKING_ID: ${GOOGLE_ANALYTICS_TRACKING_ID:-}
DISABLE_AUTH: ${DISABLE_AUTH:-false}
EOF

node - "$PWD/index.html" <<'EOF'
const fs = require('fs')

const indexFile = process.argv[2]
const defaultIcon = 'https://d2tyb7byn1fef9.cloudfront.net/ibi-logo-original%402x.png'
const title = process.env.APPLICATION_TITLE || 'Data Tools'
const shortcutIconUrl = process.env.SHORTCUT_ICON_URL || defaultIcon

const escapeHtml = (value) =>
  value
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')

let html = fs.readFileSync(indexFile, 'utf8')
html = html.replace(/<title>.*?<\/title>/, `<title>${escapeHtml(title)}</title>`)
html = html.replace(
  /<link rel="shortcut icon" href="[^"]*" type="image\/x-icon">/,
  `<link rel="shortcut icon" href="${escapeHtml(shortcutIconUrl)}" type="image/x-icon">`
)
fs.writeFileSync(indexFile, html)
EOF
