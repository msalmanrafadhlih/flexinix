{ ... }:
{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    pulseaudio.enable = false;
  };

  # Matikan PulseAudio agar tidak konflik dengan PipeWire
  hardware.pulseaudio.enable = false;
}
