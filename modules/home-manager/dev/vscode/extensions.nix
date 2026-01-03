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

    # Debugger for Java
    vscjava.vscode-java-debug

    # Dev Containers
    ms-vscode-remote.remote-containers

    # Even Better TOML
    tamasfe.even-better-toml

    # Extension Pack for Java
    vscjava.vscode-java-pack

    # GitHub Actions
    github.vscode-github-actions

    # GitHub Copilot Chat
    github.copilot-chat

    # Go
    golang.go

    # Gradle Extension Pack
    richardwillis.vscode-gradle-extension-pack

    # Gradle for Java
    vscjava.vscode-gradle

    # Gradle Language Support
    naco-siren.gradle-language

    # HashiCorp Terraform
    hashicorp.terraform

    # Hex Editor
    ms-vscode.hexeditor

    # HTML Preview
    george-alisson.html-preview-vscode

    # JSON formatter
    clemenspeters.format-json

    # KDL
    kdl-org.kdl

    # Kotlin
    fwcd.kotlin

    # Language Support for Java(TM) by Red Hat
    redhat.java

    # LaTeX Extension Pack
    leojhonsong.latex-extension-pack

    # LaTeX Workshop
    james-yu.latex-workshop

    # Log File Highlighter
    emilast.logfilehighlighter

    # LTeX - LanguageTool grammar/spell checking
    valentjn.vscode-ltex

    # Makefile Tools
    ms-vscode.makefile-tools

    # Markdown Preview Enhanced
    shd101wyy.markdown-preview-enhanced

    # Material Icon Theme
    pkief.material-icon-theme

    # Maven for Java
    vscjava.vscode-maven

    # Nix IDE
    jnoortheen.nix-ide

    # Path Intellisense
    christian-kohler.path-intellisense

    # pdf
    frinkr.pdf

    # PDF Viewer
    mathematic.vscode-pdf

    # Perfect Dark Theme
    heygourab.perfect-dark-theme

    # PlatformIO IDE
    platformio.platformio-ide

    # PowerShell
    ms-vscode.powershell

    # Project Manager for Java
    vscjava.vscode-java-dependency

    # Pylance
    ms-python.vscode-pylance

    # Python  
    ms-python.python

    # Python Debugger
    ms-python.debugpy

    # Rainbow CSV
    mechatroner.rainbow-csv

    # Remote - SSH
    ms-vscode-remote.remote-ssh

    # Remote - SSH: Editing Configuration Files
    ms-vscode-remote.remote-ssh-edit

    # Remote Explorer
    ms-vscode.remote-explorer

    # Shell Format
    foxundermoon.shell-format

    # Spring Boot Dashboard
    vscjava.vscode-spring-boot-dashboard

    # Spring Boot Extension Pack
    vmware.vscode-boot-dev-pack

    # Spring Boot Tools
    vmware.vscode-spring-boot

    # Spring Initializr Java Support
    vscjava.vscode-spring-initializr

    # SQLTools
    mtxr.sqltools

    # Test Runner for Java
    vscjava.vscode-java-test

    # Vim
    vscodevim.vim

    # VS CTF
    alexandre-lavoie.vs-ctf
    
    # VSCode PDF
    tomoki1207.pdf
  ];
}
