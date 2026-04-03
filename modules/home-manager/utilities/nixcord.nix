{ inputs, pkgs, ... }:
let
  fakeVoiceOptions = pkgs.runCommand "fake-voice-options-plugin" { src = inputs.fakeVoiceOptions; } ''
    mkdir -p "$out"
    cp -r "$src"/. "$out"/

    mkdir -p "$out/node_modules/@api" "$out/node_modules/@components" "$out/node_modules/@utils" "$out/node_modules/@webpack"

    cat > "$out/node_modules/@api/Settings.js" <<'EOF'
    function defaultsFromSchema(schema = {}) {
      return Object.fromEntries(
        Object.entries(schema).map(([key, value]) => [key, value?.default])
      );
    }

    export function definePluginSettings(schema = {}) {
      const impl = globalThis?.Vencord?.Api?.Settings?.definePluginSettings;
      if (typeof impl === "function") {
        return impl(schema);
      }

      const store = defaultsFromSchema(schema);
      return {
        store,
        plain: store,
        use: () => store,
      };
    }
    EOF

    cat > "$out/node_modules/@api/Styles.js" <<'EOF'
    export function enableStyle() {}
    export function disableStyle() {}
    EOF

    cat > "$out/node_modules/@components/ErrorBoundary.js" <<'EOF'
    export default function ErrorBoundary(props) {
      return props.children ?? null;
    }
    EOF

    cat > "$out/node_modules/@utils/constants.js" <<'EOF'
    export const Devs = {
      SaucyDuck: { name: "SaucyDuck", id: 1004904120056029256n },
      GeorgeV22: { name: "GeorgeV22", id: 0n },
      thororen: { name: "thororen", id: 0n },
    };
    EOF

    cat > "$out/node_modules/@utils/types.js" <<'EOF'
    export const OptionType = {
      STRING: 0,
      NUMBER: 1,
      BIGINT: 2,
      BOOLEAN: 3,
      SELECT: 4,
      SLIDER: 5,
      COMPONENT: 6,
      CUSTOM: 7,
    };

    export default function definePlugin(plugin) {
      return plugin;
    }
    EOF

    cat > "$out/node_modules/@utils/react.js" <<'EOF'
    export function LazyComponent(factory) {
      return (...args) => {
        const component = typeof factory === "function" ? factory() : factory;
        if (typeof component === "function") {
          return component(...args);
        }
        return null;
      };
    }
    EOF

    cat > "$out/node_modules/@webpack/index.js" <<'EOF'
    const fallbackFilters = {
      byCode: () => () => false,
      byDisplayName: () => () => false,
      byProps: () => () => false,
      byStoreName: () => () => false,
    };

    export const filters = globalThis?.Vencord?.Webpack?.filters ?? fallbackFilters;

    export function find(...args) {
      const impl = globalThis?.Vencord?.Webpack?.find;
      return typeof impl === "function" ? impl(...args) : undefined;
    }
    EOF
  '';
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    userPlugins = {
      fakeVoiceOptions = fakeVoiceOptions;
    };
    equicordConfig = {
      plugins = {
        "Fake Voice Options" = {
          enabled = true;
          fakeMute = true;
          fakeDeafen = true;
        };
      };
    };
    discord = {
      vencord.enable = false;
      equicord.enable = true;
    };
    config = {
      autoUpdate = true;
      plugins = {
        fakeNitro.enable = true;
        noNitroUpsell.enable = true;
        questify = {
          enable = true;
          completeAchievementQuestsInBackground = true;
          completeGameQuestsInBackground = true;
          completeVideoQuestsInBackground = true;
        };
        spotifyActivityToggle.enable = true;
        spotifyCrack = {
          enable = true;
          noSpotifyAutoPause = false;
        };
        musicControls = {
          enable = true;
          hoverControls = true;
          showSpotifyControls = true;
          showSpotifyLyrics = true;
          useSpotifyUris = true;
        };
        messageLoggerEnhanced.enable = true;
        channelTabs.enable = true;
        showHiddenChannels.enable = true;
        summaries.enable = true;
        splitLargeMessages = {
          enable = true;
          disableFileConversion = true;
        };
        previewMessage.enable = true;
      };
    };
  };
}
