default[:stunnel][:service] = "stunnel4"
default[:stunnel][:package] = "stunnel4"
default[:stunnel][:dir] = "/etc/stunnel"
default[:stunnel][:chroot] = "/var/lib/stunnel4/"
default[:stunnel][:uid] = "stunnel4"
default[:stunnel][:gid] = "stunnel4"
default[:stunnel][:accept] = "127.0.0.1:6379"

# loading from roles
default[:stunnel][:connect] = ""
