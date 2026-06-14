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
      # GPU Passthrough Hook for eGPU (Thunderbolt-connected AMD GPU)
      MODPROBE="/run/current-system/sw/bin/modprobe"
      LOGFILE="/var/log/libvirt-gpu-passthrough.log"
      
      GUEST_NAME="$1"
      OPERATION="$2"
      
      GPU_VGA="0000:2f:00.0"
      GPU_AUDIO="0000:2f:00.1"

      log() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
      }

      # Check if device exists in sysfs
      device_exists() {
        [[ -d "/sys/bus/pci/devices/$1" ]]
      }

      # Get current driver binding
      get_driver() {
        local device=$1
        if [[ -L "/sys/bus/pci/devices/$device/driver" ]]; then
          basename "$(readlink "/sys/bus/pci/devices/$device/driver")"
        else
          echo "unbound"
        fi
      }

      # Wait for device to be available
      wait_for_device() {
        local device=$1
        local max_wait=5
        local waited=0
        
        while ! device_exists "$device" && [[ $waited -lt $max_wait ]]; do
          log "Waiting for device $device to appear... ($waited/$max_wait)"
          sleep 1
          ((waited++))
        done
        
        if ! device_exists "$device"; then
          log "ERROR: Device $device not found in sysfs after $max_wait seconds"
          return 1
        fi
        return 0
      }

      # Safely unbind device
      safe_unbind() {
        local device=$1
        local driver=$(get_driver "$device")
        
        if [[ "$driver" == "unbound" ]]; then
          log "$device is already unbound"
          return 0
        fi
        
        if [[ ! -d "/sys/bus/pci/devices/$device/driver" ]]; then
          log "Warning: Cannot unbind $device - driver path missing"
          return 0
        fi
        
        log "Unbinding $device from $driver"
        if echo "$device" > "/sys/bus/pci/devices/$device/driver/unbind" 2>/dev/null; then
          log "Successfully unbound $device from $driver"
          return 0
        else
          log "Failed to unbind $device from $driver"
          return 1
        fi
      }

      # Safely bind device
      safe_bind() {
        local device=$1
        local driver=$2
        
        # Check if driver module exists
        if [[ ! -d "/sys/bus/pci/drivers/$driver" ]]; then
          log "ERROR: Driver directory /sys/bus/pci/drivers/$driver does not exist"
          log "Attempting to load $driver module..."
          $MODPROBE "$driver" 2>&1 | while read line; do log "  modprobe: $line"; done
          sleep 1
        fi
        
        if [[ ! -f "/sys/bus/pci/drivers/$driver/bind" ]]; then
          log "ERROR: Cannot bind to $driver - bind file missing"
          return 1
        fi
        
        # Clear any existing driver override
        echo "" > "/sys/bus/pci/devices/$device/driver_override" 2>/dev/null
        sleep 0.2
        
        # Set driver override to prevent other drivers from claiming it
        echo "$driver" > "/sys/bus/pci/devices/$device/driver_override" 2>/dev/null
        sleep 0.2
        
        # Attempt to bind
        log "Binding $device to $driver..."
        local output
        output=$(echo "$device" > "/sys/bus/pci/drivers/$driver/bind" 2>&1)
        if [[ $? -eq 0 ]]; then
          log "Successfully bound $device to $driver"
          return 0
        else
          log "ERROR binding $device to $driver: $output"
          return 1
        fi
      }

      if [[ "$GUEST_NAME" == "win11" ]]; then
        if [[ "$OPERATION" == "prepare" ]]; then
          log "=== Starting GPU passthrough preparation ==="
          
          # Verify both devices exist
          if ! wait_for_device "$GPU_VGA" || ! wait_for_device "$GPU_AUDIO"; then
            log "ERROR: Cannot proceed - devices not available. Aborting passthrough."
            exit 1
          fi
          
          # Check current state
          local vga_driver=$(get_driver "$GPU_VGA")
          local audio_driver=$(get_driver "$GPU_AUDIO")
          log "Current state - VGA: $vga_driver, Audio: $audio_driver"
          
          # Save driver states for restoration
          echo "$vga_driver" > "/tmp/gpu_vga_driver" 2>/dev/null
          echo "$audio_driver" > "/tmp/gpu_audio_driver" 2>/dev/null
          
          # Check if Intel iGPU is available and can be used for display
          if lspci -nn | grep -q "Intel.*Arc.*Graphics\|Intel.*Arc"; then
            log "Intel iGPU detected - can safely pass through AMD GPU"
          else
            log "WARNING: No Intel iGPU detected - display may be lost after passthrough"
          fi
          
          # Unbind from native drivers (but abort if this fails for VGA - we need that for fallback)
          if safe_unbind "$GPU_VGA"; then
            sleep 0.5
          else
            log "WARNING: Failed to unbind VGA - may conflict with passthrough"
          fi
          
          safe_unbind "$GPU_AUDIO"
          sleep 0.5
          
          # Ensure vfio-pci is loaded
          $MODPROBE vfio-pci 2>&1 | while read line; do log "  modprobe: $line"; done
          sleep 1
          
          # Bind to VFIO
          if safe_bind "$GPU_VGA" "vfio-pci"; then
            sleep 0.5
            safe_bind "$GPU_AUDIO" "vfio-pci" || log "WARNING: Audio binding failed, VGA passthrough will still work"
          else
            # Critical failure - rebind to native drivers to recover display
            log "CRITICAL: VGA passthrough binding failed - recovering display"
            echo "" > "/sys/bus/pci/devices/$GPU_VGA/driver_override" 2>/dev/null
            safe_bind "$GPU_VGA" "amdgpu" || log "ERROR: Could not recover to amdgpu!"
            exit 1
          fi
          
          log "=== GPU passthrough preparation complete ==="

        elif [[ "$OPERATION" == "release" ]]; then
          log "=== Starting GPU passthrough release ==="
          
          if ! wait_for_device "$GPU_VGA" || ! wait_for_device "$GPU_AUDIO"; then
            log "WARNING: Devices not available for release, skipping"
            exit 0
          fi
          
          # Unbind from VFIO
          safe_unbind "$GPU_VGA"
          safe_unbind "$GPU_AUDIO"
          sleep 1
          
          # Clear driver overrides
          echo "" > "/sys/bus/pci/devices/$GPU_VGA/driver_override" 2>/dev/null
          echo "" > "/sys/bus/pci/devices/$GPU_AUDIO/driver_override" 2>/dev/null
          sleep 0.5
          
          # Restore to native drivers
          local vga_driver=$(cat "/tmp/gpu_vga_driver" 2>/dev/null || echo "amdgpu")
          local audio_driver=$(cat "/tmp/gpu_audio_driver" 2>/dev/null || echo "snd_hda_intel")
          
          safe_bind "$GPU_VGA" "$vga_driver"
          sleep 0.5
          safe_bind "$GPU_AUDIO" "$audio_driver"
          
          log "=== GPU passthrough release complete ==="
        fi
      fi
    '';
    mode = "0755";
  };
}