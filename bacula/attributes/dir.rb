include_attribute "bacula"

default[:bacula][:dir][:port] = "9101"
default[:bacula][:dir][:message] = "Daemon"
default[:bacula][:dir][:enable_tls] = true
default[:bacula][:dir][:jobs] = Mash.new
default[:bacula][:dir][:storage_resources] = Mash.new

config_dir = "/etc/bacula"
query_file = "/usr/libexec/bacula/query.sql"
bacula_dir_service = "bacula-dir"

case platform
when "debian"
    bacula_dir = "bacula-server"
    bacula_dir_service = "bacula-director"

when "freebsd"
    bacula_dir = "bacula-server"
    config_dir = "/usr/local#{config_dir}"
    query_file = "/usr/local/share/bacula/query.sql"

when "gentoo"
    bacula_dir = "app-backup/bacula"
end

default[:bacula][:dir][:package] = bacula_dir
default[:bacula][:dir][:config_dir] = config_dir
default[:bacula][:dir][:query_file] = query_file
default[:bacula][:dir][:service] = bacula_dir_service

# setting via role
default[:bacula][:dir][:console_password] = ""
