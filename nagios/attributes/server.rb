include_attribute "nagios::service"
include_attribute "nagios::checkcommands"

default[:nagios][:server][:authorized_key] = ""
default[:nagios][:server][:contact_groups] = ""
default[:nagios][:server][:use] = ""
default[:nagios][:server][:hostgroups] = []
default[:nagios][:server][:autoregister_services] = []

nagios = "nagios"
nagios_dir = "/etc/nagios3"
nagios_uid = "nagios"
nagios_gid = "nagios"
nagios_homedir = "/home/nagios"
nagios_service = "nagios"
nagios_real_user1   = "/usr/lib/nagios"

case platform
when "gentoo"
    nagios = "net-analyzer/nagios"
when "debian"
    nagios_gid = "www-data"
    nagios = "nagios3"
    nagios_service = "nagios3"
end

default[:nagios][:server][:dir] = nagios_dir
default[:nagios][:server][:homedir] = nagios_homedir
default[:nagios][:server][:package] = nagios
default[:nagios][:server][:service] = nagios_service

default[:nagios][:server][:uid] = nagios_uid
default[:nagios][:server][:gid] = nagios_gid
