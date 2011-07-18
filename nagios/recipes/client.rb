server_hosts = node.nagios.client.hosts

search(:node, "role:nagios_server") do |s|
    s["network"]["interfaces"]["eth0"]["addresses"].each do |addr, prop|
        server_hosts.push addr if (prop[:family] == "inet6") && addr !~ /^fe80/
    end
end

user "nagios" do
    home node.nagios.client.dir
    action [:create, :unlock]
    password '*'
end

package node.nagios.client.package do
    action :install
end

directory node.nagios.client.dir do
    owner "nagios"
    group "nagios"
    mode  0700
end

directory "#{node.nagios.client.dir}/.ssh" do
    owner "nagios"
    group "nagios"
    mode  0700
end

template "#{node.nagios.client.dir}/.ssh/authorized_keys" do
    source "authorized_keys"
    owner "nagios"
    group "nagios"
    mode  0600
    variables :authorized_key => node.nagios.server.authorized_key,
              :servers        => server_hosts
end
