{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  resticPassword = config.age.secrets.restic_password.path;
  rcloneConf = config.age.secrets.rclone-conf.path;

  commonConfig = {
    initialize = true;
    paths = ["/persist" "/home" "/var/lib/sbctl"];
    passwordFile = resticPassword;
    rcloneConfigFile = rcloneConf;
    exclude = [
      "/home/*/.cache"
      "/home/*/.local/share/Trash"
    ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
    };
  };

  repos = {
    nas = "rclone:nas:homes/ang3lo/backups/pc-angelo";
    gdrive-shared = "rclone:gdrive_shared_drive:/backups/pc-angelo";
  };

  # Shared constraints for all network-dependent backup/check services.
  networkACService = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    unitConfig.ConditionACPower = true;
    startLimitIntervalSec = 12 * 60 * 60;
    startLimitBurst = 1;
  };

  # Send a desktop notification as ang3lo from a root service.
  desktopNotify = title: body: ''
    runuser -u ang3lo -- \
      env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send --urgency=critical \
        ${lib.escapeShellArg title} ${lib.escapeShellArg body}
  '';
in {
  services.restic.backups = {
    nas = commonConfig // {repository = repos.nas;};
    gdrive-shared = commonConfig // {repository = repos.gdrive-shared;};
  };

  environment.systemPackages = [
    pkgs.restic
    pkgs.rclone
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.rem
  ];

  systemd.services = lib.mkMerge (
    [
      # Server-side GDrive mirror immediately after the Shared Drive backup completes.
      {
        restic-backups-gdrive-shared.postStart = ''
          echo "Restic backup complete! Triggering Google Server-Side Sync to personal drive..."
          ${pkgs.rclone}/bin/rclone sync -v --drive-server-side-across-configs \
            --config ${rcloneConf} \
            gdrive_shared_drive:/backups/pc-angelo gdrive:/backups/pc-angelo
        '';
      }
    ]
    ++ lib.mapAttrsToList (name: repo: {
      # Hook failure notifications onto each backup job.
      "restic-backups-${name}" =
        networkACService
        // {
          unitConfig =
            networkACService.unitConfig
            // {
              OnFailure = "restic-backup-failed-${name}.service";
            };
        };
      "restic-backup-failed-${name}" = {
        description = "Notify restic backup failure: ${name}";
        script = desktopNotify "Backup Failed" "Restic backup [${name}] failed. Check: journalctl -u restic-backups-${name}";
        serviceConfig.Type = "oneshot";
      };

      # Weekly integrity check for each repo.
      "restic-check-${name}" =
        networkACService
        // {
          description = "Restic integrity check: ${name}";
          unitConfig =
            networkACService.unitConfig
            // {
              OnFailure = "restic-check-failed-${name}.service";
            };
          environment.RCLONE_CONFIG = rcloneConf;
          script = ''
            ${pkgs.restic}/bin/restic --repo ${lib.escapeShellArg repo} \
              --password-file ${resticPassword} check --read-data-subset=2.5%
          '';
          serviceConfig.Type = "oneshot";
        };
      "restic-check-failed-${name}" = {
        description = "Notify restic check failure: ${name}";
        script = desktopNotify "Backup Check Failed" "Restic check [${name}] failed. Run: restic -r ${repo} check";
        serviceConfig.Type = "oneshot";
      };
    })
    repos
  );

  systemd.timers = lib.mapAttrs' (name: _:
    lib.nameValuePair "restic-check-${name}" {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "weekly";
        RandomizedDelaySec = "2h";
        Persistent = true;
      };
    })
  repos;
}
