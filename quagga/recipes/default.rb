package node.quagga.package do
    action :install
end

service node.quagga.service do
    action :enable
end

if node.platform == "debian"
    template "#{node.quagga.dir}/daemons" do
        source "etc/quagga/daemons"
        owner node.quagga.uid
        group node.quagga.gid
        variables (:quagga_services => node.quagga.services)
        notifies :restart, resources(:service => node.quagga.service)
    end
end
