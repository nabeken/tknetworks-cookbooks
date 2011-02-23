package = "bacula-sd"
config  = "/etc/bacula/bacula-sd.conf"

case platform
when "freebsd"
    package = "bacula-server"
    config  = "/usr/local#{config}"

when "gentoo"
    package = "app-backup/#{package}"
end

default[:bacula][:sd][:package] = package
default[:bacula][:sd][:config]  = config
default[:bacula][:sd][:devices] = Mash.new
default[:bacula][:sd][:service] = "bacula-sd"
