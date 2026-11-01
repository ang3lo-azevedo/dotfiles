{config, ...}: let
  # Each box gets its own home so distro-specific dotfiles and pip installs
  # never land in the Home Manager managed one.
  boxHome = name: "${config.xdg.dataHome}/distrobox/${name}";
  # One box per glibc generation, to run pwn challenges against the libc they were built for
  # mkPwnBox = release: {
  #   image = "docker.io/library/ubuntu:${release}";
  #   home = boxHome "pwn-${release}";
  #   additional_packages = "gdb gdbserver strace ltrace file binutils patchelf libc6-dbg libc6-i386 python3-pip";
  # };
in {
  programs.distrobox = {
    enable = true;

    containers = {
      kali = {
        image = "docker.io/kalilinux/kali-rolling:latest";
        home = boxHome "kali";
        additional_packages = "kali-linux-headless";
        # tpm-udev's postinst runs systemd-tmpfiles, which chowns the host TPM nodes
        # (/dev/tpm0, ...). That is not permitted in the rootless container and aborts
        # distrobox's package setup with exit 100. The postinst does not exist yet when
        # this hook runs, so mask the tmpfiles config instead: a same-named empty file in
        # /etc/tmpfiles.d overrides the one the package ships in /usr/lib/tmpfiles.d.
        # Only applies when the container is created, so recreate it after changing this.
        pre_init_hooks = "mkdir -p /etc/tmpfiles.d && : > /etc/tmpfiles.d/tpm-udev.conf";
      };

      blackarch = {
        image = "docker.io/library/archlinux:latest";
        home = boxHome "blackarch";
        # TODO: See if curl is necessary
        additional_packages = "curl";
        # init hooks run on every start, so only bootstrap the repo once
        init_hooks = "grep -q blackarch /etc/pacman.conf || { curl -fsSL -o /tmp/strap.sh https://blackarch.org/strap.sh && bash /tmp/strap.sh; }";
      };

      #"pwn-20.04" = mkPwnBox "20.04";
      #"pwn-22.04" = mkPwnBox "22.04";
      #"pwn-24.04" = mkPwnBox "24.04";
    };
  };
}
