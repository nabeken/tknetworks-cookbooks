working_dir = "/var/lib/bacula"
pid_dir     = "/var/run"
config_dir  = "/etc/bacula"

case platform
when "freebsd"
    working_dir = "/var/db/bacula"
    config_dir  = "/usr/local#{config_dir}"
end

default[:bacula][:pid_dir]     = pid_dir
default[:bacula][:working_dir] = working_dir
default[:bacula][:config_dir]  = config_dir
default[:bacula][:maximum_concurrent_jobs] = 50
default[:bacula][:uid] = "bacula"
default[:bacula][:gid] = "bacula"

# setting via role
default[:bacula][:tls][:enable] = true
default[:bacula][:tls][:cn] = ""
default[:bacula][:tls][:ca] = ""
default[:bacula][:tls][:cert] = ""
default[:bacula][:tls][:key] = ""
