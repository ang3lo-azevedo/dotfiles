{
  # Enable IOMMU
  boot.kernelParams = [ 
    "intel_iommu=on" 
    "iommu=pt"
    #"vfio-pci.ids=1002:7590,1002:ab40"
  ];
  
  boot.kernelModules = [ "kvm-intel" "vfio_pci" "vfio" "vfio_iommu_type1" ];

  # Load VFIO Modules
  #boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];

  # This creates the script that unbinds AMD from Linux and binds to VFIO
  systemd.services.libvirtd.preStart = ''
    mkdir -p /var/lib/libvirt/hooks
    ln -sf /etc/libvirt/hooks/qemu /var/lib/libvirt/hooks/qemu
  '';

  environment.etc."libvirt/hooks/qemu" = {
    text = ''
      #!/run/current-system/sw/bin/bash
      # Use full paths for NixOS compatibility
      MODPROBE="/run/current-system/sw/bin/modprobe"
      
      GUEST_NAME="$1"
      OPERATION="$2"
      
      GPU_VGA="0000:2f:00.0"
      GPU_AUDIO="0000:2f:00.1"

      if [[ "$GUEST_NAME" == "win11" ]]; then
        if [[ "$OPERATION" == "prepare" ]]; then
          echo "$GPU_VGA" > /sys/bus/pci/devices/"$GPU_VGA"/driver/unbind || true
          echo "$GPU_AUDIO" > /sys/bus/pci/devices/"$GPU_AUDIO"/driver/unbind || true
          
          $MODPROBE vfio-pci
          echo "vfio-pci" > /sys/bus/pci/devices/"$GPU_VGA"/driver_override
          echo "vfio-pci" > /sys/bus/pci/devices/"$GPU_AUDIO"/driver_override
          echo "$GPU_VGA" > /sys/bus/pci/drivers/vfio-pci/bind || true
          echo "$GPU_AUDIO" > /sys/bus/pci/drivers/vfio-pci/bind || true

        elif [[ "$OPERATION" == "release" ]]; then
          echo "$GPU_VGA" > /sys/bus/pci/devices/"$GPU_VGA"/driver/unbind || true
          echo "$GPU_AUDIO" > /sys/bus/pci/devices/"$GPU_AUDIO"/driver/unbind || true
          
          echo "" > /sys/bus/pci/devices/"$GPU_VGA"/driver_override
          echo "" > /sys/bus/pci/devices/"$GPU_AUDIO"/driver_override
          echo "$GPU_VGA" > /sys/bus/pci/drivers/amdgpu/bind || true
          echo "$GPU_AUDIO" > /sys/bus/pci/drivers/snd_hda_intel/bind || true
        fi
      fi
    '';
    mode = "0755";
  };
}