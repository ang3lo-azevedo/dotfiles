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
      # Cache
      "/home/*/.cache"

      # Trash
      "/home/*/.local/share/Trash"

      # VMs
      #"/persist/var/lib/libvirt/images"

      # Core dumps
      "/persist/var/lib/systemd/coredump"
    ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
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

    # Skip backup on battery, avoids draining the battery and slowing the machine mid-backup
    unitConfig.ConditionACPower = true;

    # Allow at most one catch-up run per 12-hour window when Persistent=true fires after a missed timer
    startLimitIntervalSec = 12 * 60 * 60;
    startLimitBurst = 1;
  };

  # Send a desktop notification as ang3lo from a root service.
  desktopNotify = urgency: title: body: ''
    ${pkgs.util-linux}/bin/runuser -u ang3lo -- \
      env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send --urgency=${urgency} \
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
      # Hook start/success/failure notifications onto each backup job.
      "restic-backups-${name}" =
        networkACService
        // {
          # Show a different notification if the backup is overdue (machine was off at the
          # scheduled time and Persistent=true triggered a catch-up run).
          preStart = ''
            mkdir -p /persist/var/lib/restic
            state_file=/persist/var/lib/restic/last-run-${name}
            if [ -f "$state_file" ]; then
              last_run=$(cat "$state_file")
              now=$(date +%s)
              age=$((now - last_run))
              if [ "$age" -gt 82800 ]; then
                title="Missed Backup Starting"
                body="Backup [${name}] was overdue, running now."
              else
                title="Backup Started"
                body="Restic backup [${name}] started."
              fi
            else
              title="Backup Started"
              body="Restic backup [${name}] started."
            fi
            ${pkgs.util-linux}/bin/runuser -u ang3lo -- \
              env DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
              ${pkgs.libnotify}/bin/notify-send --urgency=normal "$title" "$body"
          '';
          unitConfig =
            networkACService.unitConfig
            // {
              OnFailure = "restic-backup-failed-${name}.service";
              OnSuccess = "restic-backup-success-${name}.service";
            };
        };
      "restic-backup-success-${name}" = {
        description = "Notify restic backup success: ${name}";
        script = ''
          date +%s > /persist/var/lib/restic/last-run-${name}
          ${desktopNotify "normal" "Backup Complete" "Restic backup [${name}] finished successfully."}
        '';
        serviceConfig.Type = "oneshot";
      };
      "restic-backup-failed-${name}" = {
        description = "Notify restic backup failure: ${name}";
        script = desktopNotify "critical" "Backup Failed" "Restic backup [${name}] failed. Check: journalctl -u restic-backups-${name}";
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
              OnSuccess = "restic-check-success-${name}.service";
            };
          environment.RCLONE_CONFIG = rcloneConf;
          script = ''
            # --read-data-subset=2.5% reads a random 2.5% of pack files each week,
            # covering the full repo over ~40 weeks without a large bandwidth spike
            ${pkgs.restic}/bin/restic --repo ${lib.escapeShellArg repo} \
              --password-file ${resticPassword} check --read-data-subset=2.5%
          '';
          serviceConfig.Type = "oneshot";
        };
      "restic-check-success-${name}" = {
        description = "Notify restic check success: ${name}";
        script = desktopNotify "normal" "Backup Check Passed" "Restic integrity check [${name}] passed.";
        serviceConfig.Type = "oneshot";
      };
      "restic-check-failed-${name}" = {
        description = "Notify restic check failure: ${name}";
        script = desktopNotify "critical" "Backup Check Failed" "Restic check [${name}] failed. Run: restic -r ${repo} check";
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
