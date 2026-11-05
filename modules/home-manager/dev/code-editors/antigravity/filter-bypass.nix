{inputs, ...}: {
  # Antigravity safety-filter lifecycle hook:
  # https://github.com/v1ktorrr0x/antigravity-filter-bypass
  # The plugin registers a `Stop` hook that inspects the last line of the last
  # model message; when the Gemini safety filter trips on a false positive
  # mid-task, it responds with a recovery directive so the agent resumes
  # instead of halting. The source tree is symlinked into the location the
  # Antigravity IDE reads its lifecycle hooks from.
  home.file.".gemini/config/plugins/antigravity-filter-bypass" = {
    source = inputs.antigravity-filter-bypass.outPath;
  };
}
