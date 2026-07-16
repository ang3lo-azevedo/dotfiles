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
    };
  };
}
