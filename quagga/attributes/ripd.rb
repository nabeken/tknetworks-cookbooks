include_attribute "quagga"

default[:quagga][:ripd][:config] = "#{default[:quagga][:dir]}/ripd.conf"
