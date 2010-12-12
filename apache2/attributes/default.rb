apache2 = "apache2"
default[:apache2][:config][:dir] = "/etc/apache2"
default[:apache2][:service] = "apache2"
default[:apache2][:use_cronolog] = true
default[:apache2][:htdocs] = "/var/www"
default[:apache2][:logs]   = "/var/log/apache2"
default[:apache2][:uid]   = "apache"
default[:apache2][:gid]   = "apache"

case platform
when "gentoo"
    apache2 = "www-servers/apache"
end

default[:apache2][:package] = apache2
