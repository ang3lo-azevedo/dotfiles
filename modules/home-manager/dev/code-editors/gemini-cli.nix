{pkgs, ...}: let
  loadSecrets = ''
    for p in /run/agenix /run/secrets; do
      if [ -z "$GOOGLE_GEMINI_BASE_URL" ] && [ -f "$p/gemini_base_url" ]; then
        export GOOGLE_GEMINI_BASE_URL="$(cat "$p/gemini_base_url")"
      fi
      if [ -z "$GEMINI_API_KEY" ] && [ -f "$p/gemini_api_key" ]; then
        export GEMINI_API_KEY="$(cat "$p/gemini_api_key")"
        export OPENAI_API_KEY="$GEMINI_API_KEY"
      fi
    done
  '';
in {
  home.packages = [
    # Wrapped `agy` that automatically loads decrypted agenix credentials
    (pkgs.writeShellScriptBin "agy" ''
      ${loadSecrets}
      exec ${pkgs.google-antigravity-cli}/bin/agy "$@"
    '')

    # Convenience `gemini` command that defaults to gemini-4-neon
    (pkgs.writeShellScriptBin "gemini" ''
      ${loadSecrets}

      args=()
      is_acp=false
      has_model=false
      for arg in "$@"; do
        if [ "$arg" = "--experimental-acp" ]; then
          is_acp=true
        elif [ "$arg" = "--yolo" ]; then
          args+=("--dangerously-skip-permissions")
        else
          if [ "$arg" = "--model" ] || [ "$arg" = "-m" ]; then
            has_model=true
          fi
          args+=("$arg")
        fi
      done

      if [ "$has_model" = false ] && [ "$is_acp" = false ] && [ "''${1:-}" != "models" ] && [ "''${1:-}" != "help" ] && [ "''${1:-}" != "--help" ]; then
        args+=("--model" "gemini-4-neon")
      fi

      if [ "$is_acp" = true ] || [ "''${1:-}" = "acp" ]; then
        exec ${pkgs.google-antigravity-cli}/bin/agy acp "''${args[@]}"
      else
        exec ${pkgs.google-antigravity-cli}/bin/agy "''${args[@]}"
      fi
    '')
  ];
}
