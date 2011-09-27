nagios_client_pkgs = []

case platform
when "debian"
  nagios_client_pkgs << "nagios-plugins"
  nagios_client_pkgs << "nagios-nrpe-server"
  nagios_client_pkgs << "nagios-nrpe-plugin"
when "gentoo"
  nagios_client_pkgs << "net-analyzer/nagios-plugins"
  nagios_client_pkgs << "net-analyzer/nagios-nrpe"
when "freebsd"
  nagios_client_pkgs << "nagios-plugins"
end

default[:nagios][:client][:dir] = "/home/nagios"
default[:nagios][:client][:packages] = nagios_client_pkgs
default[:nagios][:client][:hosts] = []

include_attribute "nagios::server"
