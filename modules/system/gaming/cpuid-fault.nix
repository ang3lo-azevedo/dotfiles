_: {
  # Intel CPUs natively support CPUID faulting (MSR_MISC_FEATURES_ENABLES,
  # arch_prctl(ARCH_CPUID_FAULT)) without needing a hypervisor, unlike AMD.
  # UMIP must be off for it to work correctly.
  boot.kernelParams = ["clearcpuid=umip"];
}
