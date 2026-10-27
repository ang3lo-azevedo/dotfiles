{
  pkgs,
  lib,
  ...
}: let
  dataDir = "/var/lib/bloodhound-ce";
  configFile = "${dataDir}/bloodhound.config.json";

  # Loopback-only toolkit on a single-user laptop, so the backends skip password
  # plumbing: postgres trusts 127.0.0.1 and neo4j runs with auth disabled. The only
  # credential that matters is the BloodHound admin login below.
  adminPassword = "BloodHoundLocal1!";

  # Rendered to the store with a placeholder for the JWT signing key, which preStart
  # fills with a random value on first launch so it is not world-readable in the store.
  # ParseConfiguration starts from BloodHound's defaults and overlays this file, so only
  # the fields that differ from the defaults need to be set here.
  configTemplate = pkgs.writeText "bloodhound.config.json" (builtins.toJSON {
    bind_addr = "127.0.0.1:8080";
    root_url = "http://localhost:8080/";
    work_dir = "${dataDir}/work";
    graph_driver = "neo4j";
    database = {
      addr = "localhost:5432";
      username = "bloodhound";
      secret = "bloodhound";
      database = "bloodhound";
    };
    neo4j = {
      addr = "localhost:7687";
      username = "neo4j";
      secret = "neo4j";
      database = "neo4j";
    };
    crypto.jwt.signing_key = "@JWT@";
    default_admin = {
      principal_name = "admin";
      password = adminPassword;
      email_address = "admin@bloodhound.local";
      first_name = "Admin";
      last_name = "User";
      # Skip the forced first-login reset: the password above is the working credential
      expire_now = false;
    };
  });

  # Starts the backend stack on demand (like the so-crates command) and opens the UI,
  # instead of leaving three database services running at every boot.
  bloodhound-launch = pkgs.writeShellScriptBin "bloodhound" ''
    set -eu

    # Like so-crates' foreground container: the command owns the stack for its lifetime,
    # so Ctrl+C (or closing it) tears the whole thing back down. journalctl is therefore
    # run without exec, so this shell stays alive to catch the signal and run cleanup.
    cleanup() {
      echo ""
      echo "Stopping BloodHound CE (API + neo4j + postgresql)..."
      sudo systemctl stop bloodhound-ce.service neo4j.service postgresql.service
      exit 0
    }
    trap cleanup INT TERM

    echo "Starting BloodHound CE (postgresql + neo4j + API)..."
    # bloodhound-ce requires both databases, so this pulls them up in order
    sudo systemctl start bloodhound-ce.service

    echo "Waiting for the API on http://localhost:8080 ..."
    for _ in $(seq 1 90); do
      if ${pkgs.curl}/bin/curl -sf -o /dev/null http://localhost:8080/ui/login; then
        break
      fi
      sleep 1
    done

    echo ""
    echo "BloodHound CE: http://localhost:8080/"
    echo "Login:         admin / ${adminPassword}"
    echo ""

    (${pkgs.xdg-utils}/bin/xdg-open http://localhost:8080/ &>/dev/null) &

    echo "Following the API log. Ctrl+C stops BloodHound CE and both databases."
    journalctl -u bloodhound-ce -f
  '';
in {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    # bloodhound-ce connects over TCP, but keep the socket off the network
    settings.listen_addresses = lib.mkDefault "localhost";
    ensureDatabases = ["bloodhound"];
    ensureUsers = [
      {
        name = "bloodhound";
        ensureDBOwnership = true;
      }
    ];
    # Prepended to pg_hba, so these win for loopback TCP; the default local peer rule
    # still provisions the database and role as the postgres superuser
    authentication = ''
      host all all 127.0.0.1/32 trust
      host all all ::1/128      trust
    '';
  };

  services.neo4j = {
    enable = true;
    defaultListenAddress = "127.0.0.1";
    bolt.listenAddress = "127.0.0.1:7687";
    # BloodHound owns its own user model; neo4j is a private backend reached only over
    # loopback, so its own auth layer is redundant here
    extraServerConfig = ''
      dbms.security.auth_enabled=false
    '';
  };

  # No wantedBy: the `bloodhound` command starts these on demand and systemd stops
  # auto-starting the databases at boot.
  systemd.services = {
    postgresql.wantedBy = lib.mkForce [];
    neo4j.wantedBy = lib.mkForce [];

    bloodhound-ce = {
      description = "BloodHound CE API server";
      after = ["postgresql.service" "neo4j.service"];
      requires = ["postgresql.service" "neo4j.service"];

      preStart = ''
        mkdir -p ${dataDir}/work
        if [ ! -f ${configFile} ]; then
          jwt=$(head -c 32 /dev/urandom | base64 -w0)
          sed "s|@JWT@|$jwt|" ${configTemplate} > ${configFile}
          chmod 600 ${configFile}
        fi
      '';

      serviceConfig = {
        ExecStart = "${pkgs.bloodhound-ce}/bin/bloodhound-ce -configfile ${configFile}";
        DynamicUser = true;
        StateDirectory = "bloodhound-ce";
        # neo4j can report ready a moment before bolt accepts connections
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };

  environment.systemPackages = [bloodhound-launch];
}
