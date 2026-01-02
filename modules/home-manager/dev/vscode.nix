{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "files.autoSave" = "afterDelay";
      };
      extensions = with pkgs.vscode-extensions; [
        #alexandre-lavoie.vs-ctf
        #clemenspeters.format-json
        #emilast.logfilehighlighter
        #frinkr.pdf
        #fwcd.kotlin
        #george-alisson.html-preview-vscode
        #github.copilot
        #github.copilot-chat
        #github.vscode-github-actions
        #golang.go
        #hashicorp.terraform
        #heygourab.perfect-dark-theme
        #james-yu.latex-workshop
        #jeff-hykin.better-nix-syntax
        #jnoortheen.nix-ide
        #kdl-org.kdl
        #leojhonsong.latex-extension-pack
        #mathematic.vscode-pdf
        #mechatroner.rainbow-csv
        #mkhl.direnv
        ms-azuretools.vscode-containers
        #ms-dotnettools.vscode-dotnet-modernize
        ms-dotnettools.vscode-dotnet-runtime
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        #ms-python.vscode-python-envs
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        #ms-vscode.cpptools-themes
        ms-vscode.hexeditor
        ms-vscode.makefile-tools
        ms-vscode.powershell
        ms-vscode.remote-explorer
        #mtxr.sqltools
        #naco-siren.gradle-language
        #openai.chatgpt
        #pinage404.nix-extension-pack
        #platformio.platformio-ide
        #redhat.java
        #richardwillis.vscode-gradle-extension-pack
        #shd101wyy.markdown-preview-enhanced
        #sirmspencer.vscode-autohide
        #slenderman00.vsirc
        #snyk-security.snyk-vulnerability-scanner
        #tamasfe.even-better-toml
        #tomoki1207.pdf
        valentjn.vscode-ltex
        #vmware.vscode-boot-dev-pack
        #vmware.vscode-spring-boot
        #vscjava.migrate-java-to-azure
        vscjava.vscode-gradle
        vscjava.vscode-java-debug
        vscjava.vscode-java-dependency
        vscjava.vscode-java-pack
        vscjava.vscode-java-test
        #vscjava.vscode-java-upgrade
        vscjava.vscode-maven
        #vscjava.vscode-spring-boot-dashboard
        vscjava.vscode-spring-initializr
        vscodevim.vim
      ];
    };
  };
}
