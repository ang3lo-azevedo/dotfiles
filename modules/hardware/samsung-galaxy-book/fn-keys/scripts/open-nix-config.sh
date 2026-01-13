#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/home/ang3lo/nix-config"

# Prefer VS Code, then VSCodium, then xdg-open via vscode://
if command -v code >/dev/null 2>&1; then
  code --reuse-window "$REPO_DIR"
elif command -v codium >/dev/null 2>&1; then
  codium --reuse-window "$REPO_DIR"
else
  # Fallback: try URL handler if registered
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "vscode://file$REPO_DIR" >/dev/null 2>&1 || {
      echo "Failed to open VS Code. Install 'code' or 'codium'." >&2
      exit 1
    }
  else
    echo "Neither 'code', 'codium' nor 'xdg-open' found." >&2
    exit 1
  fi
fi
