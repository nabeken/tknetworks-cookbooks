#
# Cookbook Name:: unbound
# Recipe:: default
#
# Copyright 2010, TKNetworks
#
# All rights reserved - Do Not Redistribute
#

package node.unbound.package do
    action :install
end

cookbook_file "/etc/named.root" do
    source "etc/named.root"
    mode 0644
    owner "root"
    group "root"
end

%w{enable start}.each do |act|
    service node.unbound.service do
        action act
    end
end

if node.platform != "gentoo"
  directory "/etc/dnssec" do
    action :create
  end
  cookbook_file "/etc/dnssec/root-anchors.txt" do
    source "etc/dnssec/root-anchors.txt"
    owner "root"
    group "root"
    mode  0644
    notifies :restart, resources(:service => node.unbound.service)
  end
end

template node.unbound.config.file do
    source "etc/unbound/unbound.conf"
    mode 0644
    owner "root"
    group "root"
    variables :allow_list => node[:unbound][:config][:allow_list], 
              :interfaces => node[:unbound][:config][:interfaces],
              :extended_statistics => node[:unbound][:config][:extended_statistics],
              :forward_zones => node[:unbound][:config][:forward_zones],
              :local_records => node[:unbound][:config][:local_records]

    notifies :restart, resources(:service => node.unbound.service)
end
