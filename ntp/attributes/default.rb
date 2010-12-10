pkg    = "ntp"
gid    = "root"
drift  = "/var/lib/ntp/ntp.drift"
config = "/etc/ntp.conf"

case platform
when "gentoo"
  service = "ntpd"
  pkg = "net-misc/ntp"
when "freebsd"
  service = "ntpd"
  drift = "/var/db/ntpd.drift"
  gid   = "wheel"
else
  service = "ntp"
end

default[:ntp][:pkg]     = pkg
default[:ntp][:gid]     = gid
default[:ntp][:drift]   = drift
default[:ntp][:config]  = config
default[:ntp][:service] = service
