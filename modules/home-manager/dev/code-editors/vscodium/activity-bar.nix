{
  lib,
  pkgs,
  ...
}: let
  # Antigravity is the reference layout: these are the view containers it pins
  # to the activity bar, in the order it shows them. Ids VSCodium does not know
  # (Antigravity's agent panel, extensions VSCodium lacks) are skipped at apply
  # time instead of being added as dead entries.
  pinned = [
    "workbench.view.explorer"
    "antigravity.agentViewContainerId"
    "workbench.view.search"
    "workbench.view.scm"
    "workbench.view.extensions"
    "workbench.view.chat.sessions"
    "workbench.view.extension.references-view"
    "workbench.view.extension.vs-ctf"
    "workbench.view.extension.securecoder-sidebar"
    "workbench.view.extension.claude-sidebar"
    "workbench.view.extension.python"
    "workbench.view.extension.claude-sessions-sidebar"
    "workbench.view.extension.ag-usage-sidebar"
    "workbench.view.extension.github-actions"
    "workbench.view.extension.latex-workshop-activitybar"
    "workbench.view.extension.cmake-view"
    "workbench.view.extension.hexExplorer"
    "workbench.view.extension.sqltoolsActivityBarContainer"
    "workbench.view.extension.tinymist-activitybar"
    "workbench.view.extension.gradleContainerView"
    "workbench.view.extension.sftp"
    "workbench.view.extension.opencode-v2"
    "workbench.view.extension.spring"
    "workbench.view.extension.todo-tree-container"
    "workbench.view.extension.roo-cline-ActivityBar"
    "workbench.view.extension.PowerShell"
  ];

  pinnedJson = pkgs.writeText "vscodium-pinned-viewlets.json" (builtins.toJSON pinned);

  # Pinned activity bar items are not a setting: they live in the state DB under
  # this key, so settings.json cannot express them.
  writerPy = pkgs.writeText "vscode-layout-writer.py" ''
    import json, shutil, sqlite3, sys, time

    KEY = "workbench.activity.pinnedViewlets2"
    AUX_KEY = "workbench.auxiliaryBar.hidden"
    db, pinned_path = sys.argv[1], sys.argv[2]

    with open(pinned_path) as f:
        rank = {vid: i for i, vid in enumerate(json.load(f))}

    con = sqlite3.connect(db)

    # 1. Enforce Auxiliary Bar is Hidden
    aux_row = con.execute("SELECT value FROM ItemTable WHERE key = ?", (AUX_KEY,)).fetchone()
    if aux_row is None or aux_row[0] != "true":
        con.execute(
            "INSERT INTO ItemTable (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value",
            (AUX_KEY, "true")
        )
        aux_updated = True
    else:
        aux_updated = False

    # 2. Sync Pinned Viewlets
    row = con.execute("SELECT value FROM ItemTable WHERE key = ?", (KEY,)).fetchone()
    if row is None:
        if aux_updated:
            con.commit()
            print(f"layout sync: {db}: hid auxiliary bar")
        else:
            print(f"layout sync: {db}: no saved layout yet, nothing to sync")
        sys.exit(0)

    current = json.loads(row[0])
    updated = []
    for entry in current:
        entry = dict(entry)
        if entry["id"] in rank:
            entry["pinned"] = True
            entry["order"] = rank[entry["id"]]
        else:
            entry["pinned"] = False
        updated.append(entry)

    if updated == current and not aux_updated:
        print(f"layout sync: {db}: already in sync")
        sys.exit(0)

    backup = "%s.pre-layout-sync-%s" % (db, time.strftime("%Y%m%d%H%M%S"))
    shutil.copy2(db, backup)
    with con:
        if updated != current:
            con.execute(
                "UPDATE ItemTable SET value = ? WHERE key = ?",
                (json.dumps(updated, separators=(",", ":")), KEY),
            )
    count = sum(1 for e in updated if e["pinned"])
    print(f"layout sync: {db}: synced {count} pinned items & auxiliary bar, backup saved to {backup}")
  '';

  applyScript = pkgs.writeShellScript "vscode-layout-apply" ''
    for userDir in "$HOME/.config/VSCodium" "$HOME/.antigravity-ide"; do
      db="$userDir/User/globalStorage/state.vscdb"
      [ -f "$db" ] || continue

      # A running VSCode rewrites its state on exit and would undo this, so only
      # touch the DB when it is closed. code.lock holds the main process PID.
      lock="$userDir/code.lock"
      if [ -f "$lock" ]; then
        pid=$(${pkgs.coreutils}/bin/tr -dc '0-9' < "$lock")
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
          echo "layout sync: skipped, editor is running for $userDir. Close it and rebuild to apply"
          continue
        fi
      fi

      ${pkgs.python3}/bin/python3 ${writerPy} "$db" ${pinnedJson}
    done
  '';
in {
  home.activation.vscodiumActivityBar = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${applyScript}
  '';
}
