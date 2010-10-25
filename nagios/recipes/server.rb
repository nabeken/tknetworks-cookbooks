user "nagios" do
    home node.nagios.server.homedir
    supports :manage_home => true
end

package node.nagios.server.package do
    action :install
end

service node.nagios.server.service do
    action :enable
end

directory node.nagios.server.dir do
    owner node.nagios.server.uid
    group node.nagios.server.gid
    mode  0770
end

%w{
    hosts
    generics
}.each do |d|
    directory "#{node.nagios.server.dir}/#{d}" do
        owner node.nagios.server.uid
        group node.nagios.server.gid
        mode  0770
    end
end

%w{
    nagios.cfg
    resource.cfg
}.each do |f|
    template "#{node.nagios.server.dir}/#{f}" do
        source "etc/nagios3/#{f}"
        owner node.nagios.server.uid
        group node.nagios.server.gid
        mode  0770
        variables :dir => node.nagios.server.dir
        notifies :restart, resources(:service => node.nagios.server.service)
    end
end

%w{
    cgi.cfg
    contact.cfg
    hostgroups.cfg
    misccommands.cfg
    timeperiods.cfg
}.each do |f|
    template "#{node.nagios.server.dir}/#{f}" do
        source "etc/nagios3/#{f}"
        owner node.nagios.server.uid
        group node.nagios.server.gid
        mode  0770
        notifies :restart, resources(:service => node.nagios.server.service)
    end
end

extend Chef::Nagios

# roleベースでホストの自動設定
hosts = {}

search(:node, "role:nagios_client") do |s|
    hosts[s["fqdn"]] = nagios_host s["fqdn"] do
        use "generic-server"
    end
end

# roleベースでサービスの自動設定
nagios_service "ping" do
    use "generic-service"
    hostgroups node.nagios.server.hostgroups
    command ["check_ping", "2000.0,50%", "2000.0,80%"]
    description "Ping monitoring"
end

node.nagios.server.autoregister_services.each do |name|
    search(:node, "role:nagios_service_#{name}") do |n|
        # roleベースで監視用コマンドの自動設定
        Chef::Log.info("autoregistering service #{name} on #{n.fqdn}")
        nagios_service name do
            use n.nagios.service[name][:use]
            host n[:fqdn]
            command n.nagios.service[name][:command]
        end

        # roleベースで各コマンドの引数を自動設定
        Chef::Log.info("autoregistering checkcommands #{name}")
        nagios_checkcommand n.nagios.checkcommands[name][:name] do
            command_line n.nagios.checkcommands[name][:command]
        end
    end
end

# here, you can define nagios host, service, checkcommand via definitions
include_recipe "nagios::myhosts"
include_recipe "nagios::myservices"
include_recipe "nagios::mycheckcommands"
