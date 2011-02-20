default[:xen][:domU][:kernel]  = "/boot/xen/kernel-genkernel-x86_64-2.6.37-gentoo-domU"
default[:xen][:domU][:ramdisk] = "/boot/xen/initramfs-genkernel-x86_64-2.6.37-gentoo-domU"
default[:xen][:domU][:root]    = "/dev/ram0 ro console=hvc0 real_root=/dev/xvda2"
default[:xen][:domU][:extra]   = "xencons=tty"
default[:xen][:domU][:cpus]    = [0, 1]
default[:xen][:domU][:vcpus]   = 2
default[:xen][:config][:dir]   = "/etc/xen"
