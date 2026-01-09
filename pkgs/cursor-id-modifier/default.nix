{
  bash,
  curl,
  writeShellScriptBin,
}:

# Create a wrapper script that downloads and runs the Linux ID modifier script
# This avoids needing to package the entire repo or binary
writeShellScriptBin "cursor-id-modifier" ''
  set -euo pipefail
  
  SCRIPT_URL="https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_linux_id_modifier.sh"
  TEMP_SCRIPT=$(mktemp)
  
  # Download the script
  ${curl}/bin/curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"
  chmod +x "$TEMP_SCRIPT"
  
  # Run the script (it will handle downloading the binary if needed)
  ${bash}/bin/bash "$TEMP_SCRIPT"
  
  # Cleanup
  rm -f "$TEMP_SCRIPT"
''
