dir = "/etc/quagga"
quagga = "quagga"
service = "quagga"
uid = "quagga"
gid = "quaggavty"

case platform
when "freebsd"
    dir = "/usr/local/etc/quagga"
when "gentoo"
    quagga = "net-misc/quagga"
when "debian"
    default[:quagga][:daemons] = {}
end

default[:quagga][:dir] = dir
default[:quagga][:package] = quagga
default[:quagga][:service] = service
default[:quagga][:uid] = uid
default[:quagga][:gid] = gid

include_attribute "quagga::zebra"
