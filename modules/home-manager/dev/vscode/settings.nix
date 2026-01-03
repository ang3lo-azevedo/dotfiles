{
  programs.vscode.profiles.default.userSettings = {
    # Controls [auto save](https://code.visualstudio.com/docs/editor/codebasics#_save-auto-save) of editors that have unsaved changes.
    #  - off: An editor with changes is never automatically saved.
    #  - afterDelay: An editor with changes is automatically saved after the configured `files.autoSaveDelay`.
    #  - onFocusChange: An editor with changes is automatically saved when the editor loses focus.
    #  - onWindowChange: An editor with changes is automatically saved when the window loses focus.
    "files.autoSave" = "afterDelay";

    # When enabled, will limit [auto save](https://code.visualstudio.com/docs/editor/codebasics#_save-auto-save) of editors to files that have no errors reported in them at the time the auto save is triggered. Only applies when `files.autoSave` is enabled.
    "files.autoSaveWhenNoErrors" = true;

    # When enabled, will limit [auto save](https://code.visualstudio.com/docs/editor/codebasics#_save-auto-save) of editors to files that are inside the opened workspace. Only applies when `files.autoSave` is enabled.
    "files.autoSaveWorkspaceFilesOnly" = true;

    # Controls the location of the primary side bar and activity bar. They can either show on the left or right of the workbench. The secondary side bar will show on the opposite side of the workbench.
    "workbench.sideBar.location" = "right";

    # Specifies the color theme used in the workbench when `window.autoDetectColorScheme` is not enabled.
    "workbench.colorTheme" = "Perfect Dark Theme";

    # Confirm before synchronizing Git repositories.
    "git.confirmSync" = false;

    # When set to true, commits will automatically be fetched from the default remote of the current Git repository. Setting to `all` will fetch from all remotes.
    "git.autofetch" = true;

    # Commit all changes when there are no staged changes.
    "git.enableSmartCommit" = true;

    # Start in Insert mode.
    "vim.startInInsertMode" = false;

    # Controls the display of line numbers.
    #  - off: Line numbers are not rendered.
    #  - on: Line numbers are rendered as absolute number.
    #  - relative: Line numbers are rendered as distance in lines to cursor position.
    #  - interval: Line numbers are rendered every 10 lines.
    "editor.lineNumbers" = "relative";

    # Adjust the appearance of the window controls to be native by the OS, custom drawn or hidden. Changes require a full restart to apply.
    "window.controlsStyle" = "hidden";

    # Controls whether the Explorer should ask for confirmation when deleting a file via the trash.
    "explorer.confirmDelete" = false;

    # Specifies the file icon theme used in the workbench or 'null' to not show any file icons.
    #  - null: No file icons
    #  - vs-minimal
    #  - vs-seti
    #  - material-icon-theme
    "workbench.iconTheme" = "material-icon-theme";

    # Whether to show a confirmation before removing a request and its associated edits.
    "chat.editing.confirmEditRequestRemoval" = false;

    # Adjust the default zoom level for all windows. Each increment above `0` (e.g. `1`) or below (e.g. `-1`) represents zooming `20%` larger or smaller. You can also enter decimals to adjust the zoom level with a finer granularity. See `window.zoomPerWindow` for configuring if the 'Zoom In' and 'Zoom Out' commands apply the zoom level to all windows or only the active window.
    "window.zoomLevel" = 1;

    # Controls whether the command center shows a menu for actions to control chat (requires `window.commandCenter`).
    "chat.commandCenter.enabled" = false;

    # Nix
	  # Use LSP instead of nix-instantiate and the formatter configured via `nix.formatterPath`.
    "nix.enableLanguageServer" = true; # Enable LSP.

    # Location of the nix language server command.
    "nix.serverPath" = "nil"; # The path to the LSP server executable.

    # Uncomment these to tweak settings.
    # "nix.serverSettings": {
    #   "nil": {
    #     "formatting": { "command": ["nixfmt"] }
    #   }
    # }

    # Controls whether the Explorer should ask for confirmation to move files and folders via drag and drop.
	  "explorer.confirmDragAndDrop" = false;

    # Controls the font family.
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";

    # Controls the font family of the terminal. Defaults to `editor.fontFamily`'s value.
    "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
  };
}

