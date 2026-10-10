{
  config,
  inputs,
  lib,
  pkgs,
  profileName,
  ...
}: let
  vmDir = "${config.home.homeDirectory}/vms/windows-forensics";
  uri = "qemu:///session";
  ovmf = "/run/libvirt/nix-ovmf";
  uuid = "6f0a3c1e-5b7d-4e2a-9c41-0d1f8a7b2e55";
  windowsUser = config.home.username;

  windowsIso = rec {
    name = "en-us_windows_11_enterprise_ltsc_2024_x64_dvd_965cfb00.iso";
    url = "https://archive.org/download/Windows-11-LTSC-Enterprise/${name}";
    sha256 = "157d8365a517c40afeb3106fdd74d0836e1025debbc343f2080e1a8687607f51";
    path = "${vmDir}/${name}";
  };

  # Setup key Microsoft publishes for Enterprise LTSC volume installs. quickget's
  # answer file carries the Pro one, which setup rejects for this image.
  ltscSetupKey = "M7XTQ-FN8P6-TTKYV-9D4CC-J462D";

  spiceWebdavd = pkgs.fetchurl {
    url = "https://www.spice-space.org/download/windows/spice-webdavd/spice-webdavd-x64-2.4.msi";
    hash = "sha256-8njBf8prEp61yaRrhjSvLs+vO8qJA+uaXHh08ORfgrk=";
  };
  spiceVdagent = pkgs.fetchurl {
    url = "https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/spice-vdagent-x64-0.10.0.msi";
    hash = "sha256-d2KUNXBbwn3X0lJenSCE9y26tf2/MQ6BL5EzL+GNAOs=";
  };

  zed = config.programs.zed-editor;
  zen = config.programs.zen-browser;
  zenFile = name: config.home.file."${zen.profilesPath}/${zen.profiles.${profileName}.path}/${name}".source;

  # The host's Zed and Zen setup, laid out the way Windows expects it. Left out:
  # the Nix language server and the commit message task, which need Linux
  # binaries, and Zen's spaces and mods, which the host only applies at activation.
  guestConfig = let
    zedSettings =
      removeAttrs zed.userSettings ["lsp" "languages" "window_decorations"]
      // {
        auto_install_extensions = lib.genAttrs zed.extensions (_: true);
        # nothing else updates it there
        auto_update = true;
      };
    zedKeymap = builtins.filter (k: !(lib.hasInfix "task::Spawn" (builtins.toJSON k))) zed.userKeymaps;
    zenPolicies.policies =
      zen.policies
      // {
        DisableAppUpdate = false;
        # no account on a machine that opens untrusted evidence
        DisableFirefoxAccounts = true;
      };
    # The default search engine is signed with the name of the profile folder,
    # so the folder keeps the host's name
    # Zen makes itself a fresh profile unless its install already owns one. It
    # names the install by a hash of the folder it is installed in, this is the
    # one for C:\Program Files\Zen Browser.
    install = "F0DC299D809B9700";
    profile = "Profiles/${profileName}";
    installsIni = lib.generators.toINI {} {
      ${install} = {
        Default = profile;
        Locked = 1;
      };
    };
    profilesIni = lib.generators.toINI {} {
      "Install${install}" = {
        Default = profile;
        Locked = 1;
      };
      General = {
        StartWithLastProfile = 1;
        Version = 2;
      };
      Profile0 = {
        Default = 1;
        IsRelative = 1;
        Name = profileName;
        Path = profile;
      };
    };
    json = name: value: pkgs.writeText name (builtins.toJSON value);
    fonts = with config.stylix.fonts; [monospace sansSerif];
  in
    pkgs.runCommand "windows-forensics-config" {nativeBuildInputs = [pkgs.fontconfig];} ''
      profile=$out/zen/appdata/Profiles/${profileName}
      mkdir -p $out/zed/themes $out/zen/program/distribution $profile/chrome $out/fonts

      cp ${json "settings.json" zedSettings} $out/zed/settings.json
      cp ${json "keymap.json" zedKeymap} $out/zed/keymap.json
      ${lib.concatMapStrings (theme: ''
        cp ${config.home.file."${config.xdg.configHome}/zed/themes/${theme}.json".source} $out/zed/themes/${theme}.json
      '') (lib.attrNames zed.themes)}

      cp ${json "policies.json" zenPolicies} $out/zen/program/distribution/policies.json
      cp ${pkgs.writeText "profiles.ini" profilesIni} $out/zen/appdata/profiles.ini
      cp ${pkgs.writeText "installs.ini" installsIni} $out/zen/appdata/installs.ini
      ${lib.concatMapStrings (file: ''
        cp ${zenFile file} $profile/${file}
      '') ["user.js" "containers.json" "search.json.mozlz4" "chrome/userChrome.css"]}
      cp -rL ${zenFile "extensions"} $profile/extensions

      # the settings name these fonts and Windows has neither
      for family in ${lib.escapeShellArgs (map (font: font.name) fonts)}; do
        found=
        while read -r font; do
          if fc-scan --format '%{family[0]}\n' "$font" | grep -xF "$family" >/dev/null; then
            cp "$font" $out/fonts/
            found=1
          fi
        done < <(find -L ${lib.concatMapStringsSep " " (font: "${font.package}") fonts} -name '*.[ot]tf')
        [ -n "$found" ]
      done
    '';

  # Built from the answer file embedded in the quickget script, which expects the
  # Windows, virtio-win and unattended discs as D:, E: and F:.
  unattendedIso = pkgs.runCommand "windows-forensics-unattended.iso" {nativeBuildInputs = [pkgs.cdrtools];} ''
    mkdir cd
    sed -n '/unattended\/autounattend\.xml"$/,/^EOF$/p' ${pkgs.quickemu}/bin/.quickget-wrapped \
      | sed '1d;$d' > cd/autounattend.xml
    grep -q '</unattend>' cd/autounattend.xml
    sed -i 's/[A-Z0-9]\{5\}\(-[A-Z0-9]\{5\}\)\{4\}/${ltscSetupKey}/g' cd/autounattend.xml
    grep -q '${ltscSetupKey}' cd/autounattend.xml
    # quickget names the Windows account after itself
    sed -i '/<Model>/!s|>Quickemu<|>${windowsUser}<|g' cd/autounattend.xml
    grep -q '<Username>${windowsUser}</Username>' cd/autounattend.xml
    # loading the QXL display driver blanks the screen and hangs setup on 24H2
    sed -i '/<PathAndCredentials/{N;/qxldod/{N;d}}' cd/autounattend.xml
    ! grep -q qxldod cd/autounattend.xml
    # the answer file installs both under these names
    cp ${spiceWebdavd} cd/spice-webdavd-x64-latest.msi
    cp ${spiceVdagent} cd/spice-vdagent-x64-0.10.0.msi
    # the host share only works once this script has run, so it travels on the disc
    cp ${./windows-forensics-tools.ps1} cd/install-tools.ps1
    cp -r ${guestConfig} cd/config
    mkisofs -quiet -J -joliet-long -o $out cd
  '';

  domain = inputs.nixvirt.lib.domain.writeXML {
    type = "kvm";
    name = "windows-forensics";
    inherit uuid;
    memory = {
      count = 8;
      unit = "GiB";
    };
    # virtiofs needs guest memory it can share with the host daemon
    memoryBacking = {
      source.type = "memfd";
      access.mode = "shared";
    };
    vcpu.count = 4;
    os = {
      type = "hvm";
      arch = "x86_64";
      machine = "q35";
      loader = {
        readonly = true;
        type = "pflash";
        path = "${ovmf}/edk2-x86_64-code.fd";
      };
      nvram = {
        template = "${ovmf}/edk2-i386-vars.fd";
        path = "${config.xdg.configHome}/libvirt/qemu/nvram/windows-forensics_VARS.fd";
      };
      # an empty disk falls through to the Windows installer
      boot = [{dev = "hd";} {dev = "cdrom";}];
    };
    features = {
      acpi = {};
      apic = {};
      hyperv.mode = "passthrough";
      vmport.state = false;
    };
    cpu = {
      mode = "host-passthrough";
      check = "none";
      migratable = false;
    };
    clock = {
      offset = "localtime";
      timer = [
        {
          name = "rtc";
          tickpolicy = "catchup";
        }
        {
          name = "pit";
          tickpolicy = "delay";
        }
        {
          name = "hpet";
          present = false;
        }
        {
          name = "hypervclock";
          present = true;
        }
      ];
    };
    devices = {
      emulator = "/run/libvirt/nix-emulators/qemu-system-x86_64";
      disk = [
        {
          type = "file";
          device = "disk";
          driver = {
            name = "qemu";
            type = "qcow2";
            discard = "unmap";
          };
          source.file = "${vmDir}/disk.qcow2";
          target = {
            dev = "vda";
            bus = "virtio";
          };
        }
        # The answer file expects these three as D:, E: and F:. The Windows ISO is
        # optional because a service downloads it and it may not be there yet.
        {
          type = "file";
          device = "cdrom";
          driver = {
            name = "qemu";
            type = "raw";
          };
          source = {
            file = windowsIso.path;
            startupPolicy = "optional";
          };
          target = {
            dev = "sda";
            bus = "sata";
          };
          readonly = true;
        }
        {
          type = "file";
          device = "cdrom";
          driver = {
            name = "qemu";
            type = "raw";
          };
          source.file = "${pkgs.virtio-win.src}";
          target = {
            dev = "sdb";
            bus = "sata";
          };
          readonly = true;
        }
        {
          type = "file";
          device = "cdrom";
          driver = {
            name = "qemu";
            type = "raw";
          };
          source.file = "${unattendedIso}";
          target = {
            dev = "sdc";
            bus = "sata";
          };
          readonly = true;
        }
      ];
      filesystem = {
        type = "mount";
        accessmode = "passthrough";
        driver.type = "virtiofs";
        binary.path = "${pkgs.virtiofsd}/bin/virtiofsd";
        source.dir = "${config.home.homeDirectory}/Public";
        target.dir = "host";
      };
      # libvirt's NAT bridge and not user-mode networking, so the host can reach
      # the guest's RDP port without a forward
      interface = {
        type = "bridge";
        source.bridge = "virbr0";
        mac.address = "52:54:00:f0:4e:51";
        model.type = "virtio";
      };
      channel = [
        {
          type = "unix";
          target = {
            type = "virtio";
            name = "org.qemu.guest_agent.0";
          };
        }
        {
          type = "spicevmc";
          target = {
            type = "virtio";
            name = "com.redhat.spice.0";
          };
        }
      ];
      input = {
        type = "tablet";
        bus = "usb";
      };
      tpm = {
        model = "tpm-crb";
        backend = {
          type = "emulator";
          version = "2.0";
        };
      };
      graphics = {
        type = "spice";
        autoport = true;
        listen.type = "none";
        image.compression = "off";
      };
      sound.model = "ich9";
      video.model = {
        type = "virtio";
        heads = 1;
        primary = true;
      };
      redirdev = [
        {
          bus = "usb";
          type = "spicevmc";
        }
        {
          bus = "usb";
          type = "spicevmc";
        }
      ];
    };
  };

  virsh = "${pkgs.libvirt}/bin/virsh -c ${uri}";

  # RDP is far smoother than the SPICE console, which draws every frame on the CPU.
  # The password is the one quickget's answer file sets.
  rdp = pkgs.writeShellApplication {
    name = "windows-forensics";
    runtimeInputs = [pkgs.freerdp pkgs.gawk];
    text = ''
      ${virsh} domstate windows-forensics | grep -q running || ${virsh} start windows-forensics

      # A clean shutdown through the guest agent: forcing the VM off makes Windows
      # boot into its recovery screen after a few times.
      stop() {
        echo "shutting Windows down..."
        ${virsh} shutdown windows-forensics --mode agent >/dev/null 2>&1 \
          || ${virsh} shutdown windows-forensics >/dev/null 2>&1 || true
        for _ in $(seq 60); do
          ${virsh} domstate windows-forensics | grep -q "shut off" && return
          sleep 2
        done
        echo "Windows is still shutting down" >&2
      }
      trap stop EXIT

      echo "waiting for Windows to report its address..."
      address=""
      for _ in $(seq 90); do
        address=$(${virsh} domifaddr windows-forensics --source agent 2>/dev/null \
          | awk '$3 == "ipv4" && $4 ~ /^192\.168\.122\./ { sub("/.*", "", $4); print $4; exit }' || true)
        [[ -n $address ]] && break
        sleep 2
      done
      if [[ -z $address ]]; then
        echo "the guest never reported an address" >&2
        exit 1
      fi

      # niri matches its window rule for the VM on this
      SDL_APP_ID=windows-forensics sdl-freerdp /v:"$address" /u:${windowsUser} /p:quickemu /cert:ignore \
        /dynamic-resolution +clipboard "$@" || true
    '';
  };
in {
  imports = [inputs.nixvirt.homeModules.default];

  # Runs in the user's libvirt session so the disk and the files written to the
  # share stay owned by the user.
  virtualisation.libvirt = {
    enable = true;
    # the session daemon looks for swtpm on the PATH of the client that starts it
    swtpm.enable = true;
    connections.${uri}.domains = [
      {
        definition = domain;
        # a rebuild must never shut down a running analysis session
        restart = false;
      }
    ];
  };

  home = {
    packages = [pkgs.virt-viewer rdp];

    activation = {
      # The session daemon inherits the PATH of whichever client starts it. When
      # that is this activation it still needs the setuid wrappers:
      # qemu-bridge-helper for the bridge and newuidmap for virtiofsd.
      libvirtSessionPath = lib.hm.dag.entryBefore ["NixVirt"] ''
        export PATH="/run/wrappers/bin:$PATH"
      '';

      windowsForensicsDisk = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ ! -e "${vmDir}/disk.qcow2" ]; then
          run mkdir -p "${vmDir}"
          run ${pkgs.qemu-utils}/bin/qemu-img create -q -f qcow2 "${vmDir}/disk.qcow2" 128G
        fi
      '';
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      uris = ["qemu:///system" uri];
      autoconnect = ["qemu:///system" uri];
    };
    # virt-manager keeps guest resizing off per VM, keyed by the UUID without dashes
    "org/virt-manager/virt-manager/vms/${lib.replaceStrings ["-"] [""] uuid}".resize-guest = 1;
  };

  # Fetched at login and not through the Nix store: a store path would pull 5 GB
  # of Windows into the system closure and from there into the binary cache.
  systemd.user.services.windows-forensics-iso = {
    Unit.Description = "Download the Windows 11 LTSC ISO for the windows-forensics VM";
    Install.WantedBy = ["default.target"];
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "windows-forensics-iso" ''
        set -eu
        iso="${windowsIso.path}"
        [ -e "$iso" ] && exit 0
        mkdir -p "$(dirname "$iso")"

        if ${pkgs.curl}/bin/curl -fL -C - -o "$iso.part" "${windowsIso.url}"; then
          complete=1
        else
          complete=0
        fi
        if echo "${windowsIso.sha256}  $iso.part" | ${pkgs.coreutils}/bin/sha256sum -c -; then
          mv "$iso.part" "$iso"
          exit 0
        fi
        # an interrupted download resumes on the next run, a finished one with
        # the wrong hash is corrupt and starts over
        [ "$complete" = 1 ] && rm -f "$iso.part"
        exit 1
      '';
      Restart = "on-failure";
      RestartSec = 120;
    };
  };
}
