default[:pdns][:config][:db_host]      = "127.0.0.1"
default[:pdns][:config][:db_user]      = "pdns"
default[:pdns][:config][:db_name]      = "pdns"
default[:pdns][:config][:db_password]  = ""
default[:pdns][:config][:axfr_ips]     = []
default[:pdns][:config][:bind][:inet]  = ""
default[:pdns][:config][:bind][:inet6] = ""
default[:pdns][:config][:file] = "/etc/powerdns/pdns.conf"

package = "pdns"
case platform
when "gentoo"
  package = "net-dns/pdns"
when "debian"
  package = "pdns-server"
end

default[:pdns][:package] = package
