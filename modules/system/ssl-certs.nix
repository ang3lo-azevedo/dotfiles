{
  # nixpkgs builds bake /etc/ssl/certs/ca-certificates.crt in as the default CA
  # path, so most programs find the trust store without any env var. Apps that
  # ship their own runtime (Antigravity's bundled Python, Zed's agent, etc.) use
  # OpenSSL defaults that point at FHS paths NixOS does not create, so they fail
  # TLS verification with "unable to get local issuer certificate". Exporting
  # SSL_CERT_FILE into the session environment hands those runtimes the real
  # bundle, which is honoured by CPython and anything else respecting the var.
  environment.sessionVariables.SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
}
