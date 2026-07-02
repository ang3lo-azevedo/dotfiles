# Fixes
## GitHub Actions Stuff



## Other Fixes

- [ ] Improve private repo stuff

# Wiki

- [ ] Add autocpu-freq to the wiki
- [ ] Add Binja & IDA Pro auto updates (probably with secrets) and wiki info about them
- [ ] See to use this as base for wiki https://xieby1.github.io/nix_config/

# Ideas
## Waybar Stuff

- [ ] Make if possible to click the privacy icons to disable camera and micrphone
- [ ] See about brigtness control on both monitors
- [x] Add nightlight slider to swaync


## General Stuff

- [ ] See to add auto comments and auto update of the wiki/README
- [ ] Define searxng configs
- [ ] Keep notification with current backup percentage
- [ ] Improve keybinds
- [ ] Fix webcam
- [ ] See about calendar notification times
- [ ] Add Home Assistant Controls to the waybar
- [ ] Setup a systemd user service to automatically mount a Rclone Crypt remote over Google Drive for seamless, Zero-Knowledge E2E encrypted local document storage
- [ ] See of adding this https://github.com/doomemacs/core


# TODO
## Clean System Stuff

- [ ] Check if new system would boot normally with all the configs
- [ ] Switch to tmpfs root for true amnesia (see commented block in hosts/pc-angelo/hardware/galaxybook5/disko.nix)


## Windows Stuff

- [ ] Test and improve Windows configuration: nothing matches NixOS but closest options are:
  - WinGet DSC (`winget export` + `configuration.dsc.yaml`) for declarative package management
  - PowerShell DSC for declarative system state (registry, features, services)
  - nova-nix (https://hackage.haskell.org/package/nova-nix): native Windows Nix implementation (no WSL needed), most NixOS-like option
  - DeadlySquad13 bootstrap (https://github.com/DeadlySquad13/Programming_dotfiles.bootstrap): Ansible-based cross-platform dotfile setup supporting Windows + WSL, uses encrypted secrets
  - NixThePlanet (https://github.com/MatthewCroughan/NixThePlanet/): Nix flake to provision Windows VMs reproducibly, useful for the forensics VM TODO
  - Winhance (https://github.com/memstechtips/Winhance): GUI debloater/optimizer for Windows 10/11, run via `irm "https://get.winhance.net" | iex`


## VM's Stuff

- [ ] Add virt manager and VM configs: see NixVirt (https://github.com/AshleyYakeley/NixVirt) for declarative libvirt/QEMU VM management via Nix, has Windows 11 template with Secure Boot + TPM (note: master branch frequently broken, pin a stable commit)
- [ ] Add GPU Passthrough to the VMs: see imperative-containment (https://github.com/kodicw/imperative-containment/) which combines NixVirt with mutable disk state for Windows gaming VMs, includes PCI passthrough, Hyper-V enlightenments and TPM 2.0


## Server Stuff

- [ ] Add firefly III 
- [ ] Add SimpleLogin
- [ ] Configure server
- [ ] Set up self-hosted GitHub Actions runner on server-angelo to replace GitHub-hosted runners for CI builds (eliminates minute limits, disk space issues, and dependency on third-party CI services)


## Other Stuff

- [ ] See best AI local module to have
- [ ] Improve wiki maybe do a website mainly about the packages
- [ ] See about the niri stuff https://github.com/calico32/nirilayout https://github.com/stepbrobd/nirimon https://github.com/stefonarch/niri-settings https://github.com/srinivasr/nirimod https://github.com/niri-wm/awesome-niri
- [ ] Define a forensics windows vm, maybe flare vm or win for. For reproducible Windows VM images see wfvm (https://git.m-labs.hk/M-Labs/wfvm): builds Windows images with pre-installed software as Nix layers, actively maintained
- [ ] Add wavsteg to cyber tools https://github.com/samolds/wavsteg
- [ ] Check https://til.simonwillison.net/python/cog-to-update-help-in-readme
- [ ] Add obs-studio https://nixos.wiki/wiki/OBS_Studio
- [x] Add the missing fn keys
- [ ] Add Kaon https://github.com/LorenDB/kaon
- [ ] Fix the e-gpu unplugging freeze
- [ ] Fix Zen extension settings
- [ ] Add android ROM building tools for Voltage https://docs.robotnix.org/development.html
- [ ] Fix cursor
- [ ] Add tmux
- [ ] Add neovim
- [ ] Add LaTeX
- [ ] Improve overlays
- [ ] Make some choices be true of false options