config = "/etc/unbound/unbound.conf"
unbound = "unbound"

case platform
when "gentoo"
    unbound = "net-dns/unbound"
end

default[:unbound][:package]  = unbound
default[:unbound][:service] = "unbound"

default[:unbound][:config][:file] = config
default[:unbound][:config][:extended_statistics] = true
default[:unbound][:config][:interfaces] = ['127.0.0.1', '::1']
default[:unbound][:config][:allow_list] = ['127.0.0.1/32', '::1/128']
default[:unbound][:config][:forward_zones] = Mash.new
default[:unbound][:config][:local_records] = []
