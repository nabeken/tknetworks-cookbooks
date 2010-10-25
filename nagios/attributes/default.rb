nagios_real_user1   = "/usr/lib/nagios/plugins"

case platform
when "freebsd"
    nagios_real_user1 = "/usr/local/libexec/nagios"
end

default[:nagios][:real_user1]   = nagios_real_user1
