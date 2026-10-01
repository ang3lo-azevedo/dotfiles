{lib, ...}: {
  # The agent runs `systemctl --user enable` on itself at every start. On NixOS
  # the packaged unit is a symlink into the store, so that drops a link to one
  # specific build in ~/.config/systemd/user, which outranks /etc/systemd/user
  # and keeps launching the old agent after an upgrade. Drop the link once it
  # no longer matches the system unit and restart onto the new one.
  home.activation.openlogiStaleUnit = lib.hm.dag.entryAfter ["reloadSystemd"] ''
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    system_unit="$(readlink -f /etc/systemd/user/openlogi-agent.service 2>/dev/null || true)"
    user_unit="$HOME/.config/systemd/user/openlogi-agent.service"
    if [ -n "$system_unit" ] && [ -L "$user_unit" ] && [ "$(readlink -f "$user_unit")" != "$system_unit" ]; then
      run rm -f "$user_unit" "$HOME/.config/systemd/user/graphical-session.target.wants/openlogi-agent.service"
      run systemctl --user daemon-reload || true
      run systemctl --user try-restart openlogi-agent.service || true
    fi
  '';
}
