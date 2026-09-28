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
  writerPy = pkgs.writeText "vscodium-activity-bar-writer.py" ''
    import json, shutil, sqlite3, sys, time

    KEY = "workbench.activity.pinnedViewlets2"
    db, pinned_path = sys.argv[1], sys.argv[2]

    with open(pinned_path) as f:
        rank = {vid: i for i, vid in enumerate(json.load(f))}

    con = sqlite3.connect(db)
    row = con.execute("SELECT value FROM ItemTable WHERE key = ?", (KEY,)).fetchone()
    if row is None:
        print("vscodium activity bar: no saved layout yet, nothing to sync")
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

    if updated == current:
        print("vscodium activity bar: already in sync")
        sys.exit(0)

    backup = "%s.pre-activity-bar-sync-%s" % (db, time.strftime("%Y%m%d%H%M%S"))
    shutil.copy2(db, backup)
    with con:
        con.execute(
            "UPDATE ItemTable SET value = ? WHERE key = ?",
            (json.dumps(updated, separators=(",", ":")), KEY),
        )
    count = sum(1 for e in updated if e["pinned"])
    print("vscodium activity bar: synced %d pinned items, previous state saved to %s" % (count, backup))
  '';

  applyScript = pkgs.writeShellScript "vscodium-activity-bar-apply" ''
    userDir="$HOME/.config/VSCodium"
    db="$userDir/User/globalStorage/state.vscdb"
    [ -f "$db" ] || exit 0

    # A running VSCodium rewrites its state on exit and would undo this, so only
    # touch the DB when it is closed. code.lock holds the main process PID.
    lock="$userDir/code.lock"
    if [ -f "$lock" ]; then
      pid=$(${pkgs.coreutils}/bin/tr -dc '0-9' < "$lock")
      if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        echo "vscodium activity bar: skipped, VSCodium is running. Close it and rebuild to apply"
        exit 0
      fi
    fi

    exec ${pkgs.python3}/bin/python3 ${writerPy} "$db" ${pinnedJson}
  '';
in {
  home.activation.vscodiumActivityBar = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ${applyScript}
  '';
}
