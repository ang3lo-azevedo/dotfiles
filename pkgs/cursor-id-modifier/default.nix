{
  bash,
  curl,
  writeShellScriptBin,
}:

# Create a wrapper script that downloads and runs the Linux ID modifier script
# This avoids needing to package the entire repo or binary
writeShellScriptBin "cursor-id-modifier" ''
  set -euo pipefail

  # The script needs to be run as root
  if [ "''${EUID:-$(id -u)}" -ne 0 ]; then
    echo "[ERROR] 请使用 sudo 运行此脚本 (安装和修改系统文件需要权限)"
    echo "示例: sudo cursor-id-modifier"
    exit 1
  fi

  # The downstream script writes to this log file.
  # A previous non-root invocation might have created it with wrong permissions.
  # We remove it to ensure the script can create it with root ownership.
  rm -f "/tmp/cursor_linux_id_modifier.log"
  
  SCRIPT_URL="https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_linux_id_modifier.sh"
  TEMP_SCRIPT=$(mktemp)
  
  # Download the script
  ${curl}/bin/curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"
  chmod +x "$TEMP_SCRIPT"
  
  # Patch the script to avoid it killing itself.
  # The process check is too broad and matches "cursor-id-modifier".
  # We make it more specific by looking for "/cursor" in the path.
  sed -i 's/pgrep -f "cursor"/pgrep -f "\/cursor"/' "$TEMP_SCRIPT"
  sed -i 's/pkill -f "cursor"/pkill -f "\/cursor"/' "$TEMP_SCRIPT"

  # Run the script (it will handle downloading the binary if needed)
  ${bash}/bin/bash "$TEMP_SCRIPT"
  
  # Cleanup
  rm -f "$TEMP_SCRIPT"
''
