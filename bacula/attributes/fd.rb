include_attribute "bacula"

config  = "/etc/bacula/bacula-fd.conf"

case platform
when "debian"
    package = "bacula-fd"

when "freebsd"
    package = "bacula-server"
    config  = "/usr/local#{config}"

when "gentoo"
    package = "app-backup/bacula"
end

default[:bacula][:fd][:package] = package
default[:bacula][:fd][:config]  = config
default[:bacula][:fd][:service] = "bacula-fd"
