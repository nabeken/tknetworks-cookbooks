include_attribute "quagga"

default[:quagga][:bgpd][:config] = "#{default[:quagga][:dir]}/bgpd.conf"
default[:quagga][:services]["bgpd"] = true
