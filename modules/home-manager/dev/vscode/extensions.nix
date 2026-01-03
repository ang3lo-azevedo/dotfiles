{ pkgs, ... }:
{
  programs.vscode.profiles.default.extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
    # .NET Install Tool
    ms-dotnettools.vscode-dotnet-runtime

    # Auto Hide
    sirmspencer.vscode-autohide

    # Better Nix Syntax
    jeff-hykin.better-nix-syntax

    # C/C++
    ms-vscode.cpptools

    # C/C++ Extension Pack
    ms-vscode.cpptools-extension-pack

    # C/C++ Themes
    ms-vscode.cpptools-themes

    # CMake Tools
    ms-vscode.cmake-tools

    # Container Tools
    ms-azuretools.vscode-containers

    alexandre-lavoie.vs-ctf
    clemenspeters.format-json
    emilast.logfilehighlighter
    frinkr.pdf
    fwcd.kotlin
    george-alisson.html-preview-vscode
    github.vscode-github-actions
    golang.go
    hashicorp.terraform
    heygourab.perfect-dark-theme
    james-yu.latex-workshop
    
    jnoortheen.nix-ide
    kdl-org.kdl
    leojhonsong.latex-extension-pack
    mathematic.vscode-pdf
    mechatroner.rainbow-csv
    mkhl.direnv
    ms-dotnettools.vscode-dotnet-modernize
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-python.vscode-python-envs
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.hexeditor
    ms-vscode.makefile-tools
    ms-vscode.powershell
    ms-vscode.remote-explorer
    mtxr.sqltools
    naco-siren.gradle-language
    pinage404.nix-extension-pack
    pkief.material-icon-theme
    #platformio.platformio-ide
    redhat.java
    richardwillis.vscode-gradle-extension-pack
    shd101wyy.markdown-preview-enhanced
    slenderman00.vsirc
    #snyk-security.snyk-vulnerability-scanner
    tamasfe.even-better-toml
    tomoki1207.pdf
    valentjn.vscode-ltex
    vmware.vscode-boot-dev-pack
    vmware.vscode-spring-boot
    vscjava.migrate-java-to-azure
    vscjava.vscode-gradle
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-pack
    vscjava.vscode-java-test
    vscjava.vscode-java-upgrade
    vscjava.vscode-maven
    vscjava.vscode-spring-boot-dashboard
    vscjava.vscode-spring-initializr
    vscodevim.vim

    christian-kohler.path-intellisense

    foxundermoon.shell-format
  ];
}
