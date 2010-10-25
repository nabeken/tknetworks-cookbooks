nagios_plugins = "nagios-plugins"

case platform
when "gentoo"
    nagios_plugins = "net-analyzer/nagios-plugins"
when "freebsd"
    nagios_plugins = "nagios-plugins"
end

default[:nagios][:client][:dir] = "/home/nagios"
default[:nagios][:client][:package] = nagios_plugins
default[:nagios][:client][:hosts] = []

include_attribute "nagios::server"
