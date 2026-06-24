{pkgs, ...}: let
  sources = pkgs.callPackage ../../../../../pkgs/_sources/generated.nix {};
  reverser_ai = sources.reverser_ai.src;

  # Python 3.12 environment with reverser_ai dependencies from ./requirements.txt
  python312WithReverserAI = pkgs.python312.withPackages (ps:
    with ps; [
      huggingface-hub
      llama-cpp-python
      networkx
      toml
      typer
    ]);
in {
  home = {
    # Fetch and link the plugin
    file.".binaryninja/plugins/reverser_ai".source = reverser_ai;

    # Provide an env script that Binary Ninja sources at launch
    file.".binaryninja/reverser_ai_env.sh".text = ''
      export PYTHONPATH="${python312WithReverserAI}/${pkgs.python312.sitePackages}:$PYTHONPATH"
    '';

    # Expose the plugin dependencies to the rest of the Home Manager config
    sessionVariables.PYTHONPATH = "${python312WithReverserAI}/${pkgs.python312.sitePackages}";
  };
}
