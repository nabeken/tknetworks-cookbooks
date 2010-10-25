# service node.quagga.bgpd.service do
#     action :start
# end
# 
# service node.quagga.bgpd.service do
#     action :enable
# end

include_recipe "quagga"

template "#{node.quagga.dir}/bgpd.conf" do
    source "etc/quagga/bgpd.conf"
    owner node.quagga.uid
    group node.quagga.gid
    restart = {:service => node.quagga.service}
    notifies :restart, resources(restart)
end

service node.quagga.service do
    action :start
end
