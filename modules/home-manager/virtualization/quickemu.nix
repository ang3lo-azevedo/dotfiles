{
  config,
  lib,
  pkgs,
  ...
}: let
  vmDir = "${config.home.homeDirectory}/vms";

  windowsIso = rec {
    name = "en-us_windows_11_enterprise_ltsc_2024_x64_dvd_965cfb00.iso";
    url = "https://archive.org/download/Windows-11-LTSC-Enterprise/${name}";
    sha256 = "157d8365a517c40afeb3106fdd74d0836e1025debbc343f2080e1a8687607f51";
    path = "${vmDir}/windows-forensics/${name}";
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

  # quickget only produces this ISO as a side effect of its own Windows download,
  # so it is rebuilt here from the answer file embedded in the quickget script.
  unattendedIso = pkgs.runCommand "windows-forensics-unattended.iso" {nativeBuildInputs = [pkgs.cdrtools];} ''
    mkdir cd
    sed -n '/unattended\/autounattend\.xml"$/,/^EOF$/p' ${pkgs.quickemu}/bin/.quickget-wrapped \
      | sed '1d;$d' > cd/autounattend.xml
    grep -q '</unattend>' cd/autounattend.xml
    sed -i 's/[A-Z0-9]\{5\}\(-[A-Z0-9]\{5\}\)\{4\}/${ltscSetupKey}/g' cd/autounattend.xml
    grep -q '${ltscSetupKey}' cd/autounattend.xml
    # loading the QXL display driver blanks the screen and hangs setup on 24H2
    sed -i '/<PathAndCredentials/{N;/qxldod/{N;d}}' cd/autounattend.xml
    ! grep -q qxldod cd/autounattend.xml
    # the answer file installs both under these names
    cp ${spiceWebdavd} cd/spice-webdavd-x64-latest.msi
    cp ${spiceVdagent} cd/spice-vdagent-x64-0.10.0.msi
    mkisofs -quiet -J -o $out cd
  '';

  # Paths are absolute so the VMs start from any directory, not only from vmDir.
  mkVmConf = name: extra: ''
    #!${pkgs.quickemu}/bin/quickemu --vm
    disk_img="${vmDir}/${name}/disk.qcow2"
    ${extra}
  '';

  vms = {
    # quickget names the ISO after the Kali release, so pick up whichever one it downloaded
    # kali-current = ''
    #   guest_os="linux"
    #   isos=(${vmDir}/kali-current/kali-linux-*-installer-amd64.iso)
    #   iso="''${isos[-1]}"
    #   disk_size="64G"
    #   cpu_cores="4"
    #   ram="8G"
    #   reverse shell listeners reachable from the guest's NAT side
    #   port_forwards=("4444:4444" "9001:9001")
    # '';

    # SANS SIFT is installed on top of a plain Ubuntu with
    # `sudo cast install teamdfir/sift-saltstack`. Reuses the ISO of the
    # Ubuntu 24.04 VM created in quickgui, whose name follows the point release.
    # sift = ''
    #   guest_os="linux"
    #   isos=(${vmDir}/ubuntu-24.04/ubuntu-24.04*-desktop-amd64.iso)
    #   iso="''${isos[-1]}"
    #   # large enough to hold evidence images next to the tooling
    #   disk_size="128G"
    #   cpu_cores="4"
    #   ram="8G"
    # '';

    windows-forensics = ''
      guest_os="windows"
      iso="${windowsIso.path}"
      # quickget's own virtio-win download gets replaced by a bot-check page
      fixed_iso="${pkgs.virtio-win.src}"
      # large enough to hold evidence images next to the tooling
      disk_size="128G"
      cpu_cores="4"
      ram="8G"
      tpm="on"
      secureboot="off"
    '';
  };
in {
  home.packages = [pkgs.quickemu];

  # quickget skips writing a conf that already exists, so it only fetches the ISO
  # and keeps the settings declared here.
  home.file =
    lib.mapAttrs' (name: extra:
      lib.nameValuePair "vms/${name}.conf" {
        text = mkVmConf name extra;
        executable = true;
      })
    vms
    // {
      # quickemu only attaches the unattended ISO when it sits next to the disk image
      "vms/windows-forensics/unattended.iso".source = unattendedIso;
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
