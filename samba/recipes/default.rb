#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2010, TKNetworks
#

package node.samba.pkg do
  source "ports" if node.platform == "freebsd"
  action :install
end

service node.samba.service do
  action :enable
end

template node.samba.config do
  source "smb.conf"
  owner  "root"
  group  node.samba.gid
  notifies :restart, resources(:service => node.samba.service)
end
