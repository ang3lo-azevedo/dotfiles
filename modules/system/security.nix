{pkgs, ...}: {
  # Safe Exam Browser runs its exam lockdown through polkit's pkexec, which
  # requires setuid root. The bubblewrap sandbox used by the AppImage wrapper
  # must therefore run with real privileges; otherwise bubblewrap falls back to
  # an unprivileged user namespace in which the setuid bit of pkexec is ignored
  # and the browser fails at startup with "pkexec must be setuid root".
  security.wrappers.bwrap = {
    enable = true;
    source = "${pkgs.bubblewrap}/bin/bwrap";
    setuid = true;
    owner = "root";
    group = "root";
  };
}
