include_attribute "rsync"

service = "rsync"
pid     = "/var/run/rsyncd.pid"
config  = "/etc/rsyncd.conf"

case platform
when "gentoo"
  service = "rsyncd"
when "freebsd"
  config = "/usr/local/etc/rsyncd.conf"
  service = "rsyncd"
end

default[:rsync][:server][:service] = service
default[:rsync][:server][:config]  = config
default[:rsync][:server][:pid]     = pid
default[:rsync][:server][:chroot]  = true
