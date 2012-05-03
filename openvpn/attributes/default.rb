case platform
when "freebsd"
  default[:openvpn][:dir] = "/usr/local/etc/openvpn"
  default[:openvpn][:uid] = "nobody"
  default[:openvpn][:gid] = "nogroup"
  default[:openvpn][:service] = "openvpn"
  default[:openvpn][:package] = "openvpn"
else
  default[:openvpn][:dir] = "/etc/openvpn"
  default[:openvpn][:uid] = "nobody"
  default[:openvpn][:gid] = "nogroup"
  default[:openvpn][:service] = "openvpn"
  default[:openvpn][:package] = "openvpn"
end

default[:openvpn][:ssl][:dh] = "#{default[:openvpn][:dir]}/dh.pem"
default[:openvpn][:ssl][:dh_bit] = "2048"
default[:openvpn][:max_clients] = 10

# must be set via role
default[:openvpn][:ssl][:ca] = ""
