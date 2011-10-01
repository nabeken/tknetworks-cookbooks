#
# Cookbook Name:: stunnel
# Recipe:: default
#
# Copyright 2011, TKNetworks
#

package node.stunnel.package do
  action :install
end

template "#{node.stunnel.dir}/stunnel.conf" do
  source "stunnel.conf"
  notifies :restart, "service[#{node.stunnel.service}]", :delayed
  variables :chroot => node.stunnel.chroot,
            :uid => node.stunnel.uid,
            :gid => node.stunnel.gid,
            :accept => node.stunnel.accept,
            :connect => node.stunnel.connect
end

if node.platform == "debian"
  template "/etc/default/stunnel4" do
    source "etc/default/stunnel4"
    notifies :restart, "service[#{node.stunnel.service}]", :delayed
  end
end

service node.stunnel.service do
  action [:enable, :start]
end
