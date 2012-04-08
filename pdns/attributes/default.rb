default[:pdns][:db_host]      = "127.0.0.1"
default[:pdns][:db_user]      = "pdns"
default[:pdns][:db_name]      = "pdns"
default[:pdns][:db_password]  = ""
default[:pdns][:axfr_ips]     = []
default[:pdns][:bind_inet]  = ""
default[:pdns][:bind_inet6] = ""
default[:pdns][:home_dir] = "/home/pdns"

case platform
when "gentoo"
  default[:pdns][:package] = "net-dns/pdns"
  default[:pdns][:dir] = "/etc/powerdns"
when "debian"
  default[:pdns][:package] = "pdns-server"
  default[:pdns][:dir] = "/etc/powerdns"
  default[:pdns][:deb_url] = "http://downloads.powerdns.com/releases/deb/pdns-static_3.0.1-1_#{debian[:arch]}.deb"
when "freebsd"
  # pgsql使う場合はDEFAULT_PGSQL_VER=91にする
  default[:pdns][:package] = "dns/powerdns"
  default[:pdns][:dir] = "/usr/local/etc/pdns"
end
