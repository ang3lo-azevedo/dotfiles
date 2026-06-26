{
  # rtkit gives PipeWire the ability to raise its threads to real-time priority
  # without running as root. Required for reliable low-latency audio scheduling.
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # quantum/rate set the period size and sample rate of the processing graph.
      # 64/48000 = ~1.33 ms per period, low enough for gaming but high enough to avoid xruns.
      # Halving quantum further (32) reduces latency but causes xruns on slower hardware.
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
  };
}
