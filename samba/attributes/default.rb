case platform
when "freebsd"
  pkg     = "samba34"
  config  = "/usr/local/etc/smb.conf"
  service = "samba"
  gid     = "wheel"
end

default[:samba][:pkg]     = pkg
default[:samba][:config]  = config
default[:samba][:service] = service
default[:samba][:gid]     = gid
