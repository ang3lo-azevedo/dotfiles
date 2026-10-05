# Port of the heygourab.perfect-dark-theme VS Code theme the other editors use,
# which has no Zed release.
let
  black = "#000000";
  editorBg = "#0a0a0a";
  raised = "#111111";
  border = "#2a2a2a";
  borderStrong = "#444444";
  guide = "#333333";
  dim = "#777777";
  muted = "#999999";
  text = "#bbbbbb";
  white = "#ffffff";
  highlight = "#ffffff33";
  highlightStrong = "#ffffff44";
  transparent = "#00000000";

  red = "#f56464";
  pink = "#f05b8d";
  orange = "#f99902";
  green = "#58c760";
  cyan = "#14cbb7";
  blue = "#62a6ff";
  purple = "#b675f1";

  status = name: color: {
    "${name}" = color;
    "${name}.background" = "${color}1a";
    "${name}.border" = "${color}80";
  };

  fg = color: {inherit color;};
  bold = color: {
    inherit color;
    font_weight = 700;
  };
in {
  "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
  name = "Perfect Dark";
  author = "Gourab (heygourab)";
  themes = [
    {
      name = "Perfect Dark";
      appearance = "dark";
      style =
        {
          "background" = black;
          "border" = border;
          "border.variant" = border;
          "border.focused" = borderStrong;
          "border.selected" = borderStrong;
          "border.transparent" = transparent;
          "border.disabled" = guide;
          "elevated_surface.background" = black;
          "surface.background" = black;
          "element.background" = raised;
          "element.hover" = highlight;
          "element.active" = highlightStrong;
          "element.selected" = highlight;
          "element.disabled" = raised;
          "drop_target.background" = highlight;
          "ghost_element.background" = transparent;
          "ghost_element.hover" = highlight;
          "ghost_element.active" = highlightStrong;
          "ghost_element.selected" = highlight;
          "ghost_element.disabled" = transparent;

          "text" = text;
          "text.muted" = muted;
          "text.placeholder" = muted;
          "text.disabled" = dim;
          "text.accent" = blue;
          "icon" = text;
          "icon.muted" = muted;
          "icon.disabled" = dim;
          "icon.placeholder" = muted;
          "icon.accent" = blue;
          "link_text.hover" = blue;

          "status_bar.background" = black;
          "title_bar.background" = black;
          "title_bar.inactive_background" = black;
          "toolbar.background" = editorBg;
          "tab_bar.background" = black;
          "tab.inactive_background" = black;
          "tab.active_background" = raised;
          "panel.background" = black;
          "panel.focused_border" = borderStrong;
          "pane.focused_border" = borderStrong;
          "pane_group.border" = border;

          "search.match_background" = "${orange}44";
          "search.active_match_background" = "${orange}88";

          "scrollbar.thumb.background" = "${borderStrong}99";
          "scrollbar.thumb.hover_background" = "#666666";
          "scrollbar.thumb.border" = transparent;
          "scrollbar.track.background" = transparent;
          "scrollbar.track.border" = border;

          "editor.foreground" = white;
          "editor.background" = editorBg;
          "editor.gutter.background" = editorBg;
          "editor.subheader.background" = raised;
          "editor.active_line.background" = highlight;
          "editor.highlighted_line.background" = highlight;
          "editor.line_number" = muted;
          "editor.active_line_number" = text;
          "editor.hover_line_number" = text;
          "editor.invisible" = muted;
          "editor.wrap_guide" = guide;
          "editor.active_wrap_guide" = borderStrong;
          "editor.indent_guide" = guide;
          "editor.indent_guide_active" = borderStrong;
          "editor.document_highlight.read_background" = highlight;
          "editor.document_highlight.write_background" = highlightStrong;
          "editor.document_highlight.bracket_background" = highlight;

          "terminal.background" = black;
          "terminal.foreground" = white;
          "terminal.bright_foreground" = white;
          "terminal.dim_foreground" = muted;
          "terminal.ansi.black" = black;
          "terminal.ansi.bright_black" = "#676767";
          "terminal.ansi.dim_black" = black;
          "terminal.ansi.red" = red;
          "terminal.ansi.bright_red" = red;
          "terminal.ansi.dim_red" = "${red}bf";
          "terminal.ansi.green" = green;
          "terminal.ansi.bright_green" = green;
          "terminal.ansi.dim_green" = "${green}bf";
          "terminal.ansi.yellow" = orange;
          "terminal.ansi.bright_yellow" = orange;
          "terminal.ansi.dim_yellow" = "${orange}bf";
          "terminal.ansi.blue" = blue;
          "terminal.ansi.bright_blue" = blue;
          "terminal.ansi.dim_blue" = "${blue}bf";
          "terminal.ansi.magenta" = purple;
          "terminal.ansi.bright_magenta" = purple;
          "terminal.ansi.dim_magenta" = "${purple}bf";
          "terminal.ansi.cyan" = cyan;
          "terminal.ansi.bright_cyan" = cyan;
          "terminal.ansi.dim_cyan" = "${cyan}bf";
          "terminal.ansi.white" = text;
          "terminal.ansi.bright_white" = white;
          "terminal.ansi.dim_white" = muted;

          "version_control.added" = green;
          "version_control.modified" = orange;
          "version_control.deleted" = pink;
          "version_control.word_added" = "${green}55";
          "version_control.word_deleted" = "${pink}55";
          "version_control.conflict_marker.ours" = "${green}1a";
          "version_control.conflict_marker.theirs" = "${blue}1a";

          players = [
            {
              cursor = white;
              background = white;
              selection = highlight;
            }
          ];

          syntax = {
            attribute = fg purple;
            boolean = fg blue;
            comment = fg text;
            "comment.doc" = fg text;
            constant = fg blue;
            constructor = fg blue;
            embedded = fg white;
            emphasis = {
              color = white;
              font_style = "italic";
            };
            "emphasis.strong" = bold white;
            enum = fg blue;
            function = fg purple;
            hint = fg text;
            keyword = fg pink;
            label = fg blue;
            link_text = fg blue;
            link_uri = fg blue;
            namespace = fg white;
            number = fg blue;
            operator = fg pink;
            predictive = fg dim;
            preproc = fg pink;
            primary = fg white;
            property = fg blue;
            punctuation = fg white;
            "punctuation.bracket" = fg white;
            "punctuation.delimiter" = fg white;
            "punctuation.list_marker" = fg orange;
            "punctuation.markup" = fg orange;
            "punctuation.special" = fg pink;
            selector = fg green;
            "selector.pseudo" = fg purple;
            string = fg green;
            "string.escape" = bold blue;
            "string.regex" = fg blue;
            "string.special" = fg blue;
            "string.special.symbol" = fg blue;
            tag = fg green;
            "text.literal" = fg blue;
            title = bold blue;
            type = fg blue;
            variable = fg white;
            "variable.special" = fg blue;
            variant = fg blue;
          };
        }
        // status "conflict" orange
        // status "created" green
        // status "deleted" red
        // status "error" red
        // status "hidden" dim
        // status "hint" blue
        // status "ignored" dim
        // status "info" blue
        // status "modified" orange
        // status "predictive" dim
        // status "renamed" blue
        // status "success" green
        // status "unreachable" muted
        // status "warning" orange;
    }
  ];
}
