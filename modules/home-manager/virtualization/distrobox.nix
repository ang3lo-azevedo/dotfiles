{config, ...}: let
  # Each box gets its own home so distro-specific dotfiles and pip installs
  # never land in the Home Manager managed one.
  boxHome = name: "${config.xdg.dataHome}/distrobox/${name}";

  # One box per glibc generation, to run pwn challenges against the libc they were built for
  mkPwnBox = release: {
    image = "docker.io/library/ubuntu:${release}";
    home = boxHome "pwn-${release}";
    additional_packages = "gdb gdbserver strace ltrace file binutils patchelf libc6-dbg libc6-i386 python3-pip";
  };
in {
  programs.distrobox = {
    enable = true;

    containers = {
      #kali = {
      #  image = "docker.io/kalilinux/kali-rolling:latest";
      #  home = boxHome "kali";
      #  additional_packages = "kali-linux-headless";
      #};

      blackarch = {
        image = "docker.io/library/archlinux:latest";
        home = boxHome "blackarch";
        additional_packages = "curl";
        # init hooks run on every start, so only bootstrap the repo once
        init_hooks = "grep -q blackarch /etc/pacman.conf || { curl -fsSL -o /tmp/strap.sh https://blackarch.org/strap.sh && bash /tmp/strap.sh; }";
      };

      "pwn-20.04" = mkPwnBox "20.04";
      "pwn-22.04" = mkPwnBox "22.04";
      "pwn-24.04" = mkPwnBox "24.04";
    };
  };
}
