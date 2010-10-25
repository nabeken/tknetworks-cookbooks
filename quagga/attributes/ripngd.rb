include_attribute "quagga"

default[:quagga][:ripngd][:config] = "#{default[:quagga][:dir]}/ripngd.conf"
