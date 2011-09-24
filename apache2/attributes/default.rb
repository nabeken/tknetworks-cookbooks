apache2 = "apache2"
cronolog = "cronolog"
uid = "apache"
gid = "apache"

default[:apache2][:config][:dir] = "/etc/apache2"
default[:apache2][:service] = "apache2"
default[:apache2][:use_cronolog] = true
default[:apache2][:htdocs] = "/var/www"
default[:apache2][:logs]   = "/var/log/apache2"

case platform
when "gentoo"
  apache2 = "www-servers/apache"
  cronolog = "app-admin/cronolog"
when "debian"
  uid = "www-data"
  gid = "www-data"
end

default[:apache2][:package] = apache2
default[:apache2][:cronolog] = cronolog
default[:apache2][:uid]   = uid
default[:apache2][:gid]   = gid
