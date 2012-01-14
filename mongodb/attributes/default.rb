default[:mongodb][:use_http_interface] = false
default[:mongodb][:bind_ip] = "127.0.0.1"

case platform
when "freebsd"
  default[:mongodb][:package] = "databases/mongodb"
  default[:mongodb][:service] = "mongod"
  default[:mongodb][:conf] = "/usr/local/etc/mongodb.conf"
else
  default[:mongodb][:package] = "mongodb"
  default[:mongodb][:service] = "mongodb"
  default[:mongodb][:conf] = "/etc/mongodb.conf"
end
