#!/usr/bin/env bash
# Install the AI coding CLIs used with this repository.
#
#   Claude Code : https://github.com/anthropics/claude-code
#   Codex CLI   : https://github.com/openai/codex
#
# Usage: ./scripts/setup-cli.sh

set -euo pipefail

REQUIRED_NODE_MAJOR=18

if ! command -v node >/dev/null 2>&1; then
  echo "error: node is not installed. Install Node.js ${REQUIRED_NODE_MAJOR}+ first." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "error: npm is not installed. Install Node.js ${REQUIRED_NODE_MAJOR}+ first." >&2
  exit 1
fi

node_major="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$node_major" -lt "$REQUIRED_NODE_MAJOR" ]; then
  echo "error: Node.js ${REQUIRED_NODE_MAJOR}+ required, found $(node -v)." >&2
  exit 1
fi

echo "==> Node $(node -v), npm $(npm -v)"

echo "==> Installing Claude Code"
npm install -g @anthropic-ai/claude-code

echo "==> Installing Codex CLI"
npm install -g @openai/codex

echo
echo "==> Installed:"
claude --version
codex --version

echo
echo "Next steps:"
echo "  claude   # first run walks through sign-in"
echo "  codex    # first run walks through sign-in"
