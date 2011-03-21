include_attribute "bacula"

config  = "/etc/bacula/bacula-fd.conf"
plugin  = "/usr/lib/bacula"

case platform
when "debian"
    package = "bacula-fd"

when "freebsd"
    package = "bacula-client"
    config  = "/usr/local#{config}"
    plugin  = "/usr/local/lib"

when "gentoo"
    package = "app-backup/bacula"
end

default[:bacula][:fd][:package] = package
default[:bacula][:fd][:config]  = config
default[:bacula][:fd][:service] = "bacula-fd"
default[:bacula][:fd][:plugin_dir] = plugin
