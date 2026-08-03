  # nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaflawaettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerflawaanagement.enable = false;
  };
