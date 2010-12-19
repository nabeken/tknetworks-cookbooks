#
# Cookbook Name:: istgt
# Recipe:: default
#
# Copyright 2010, TKNetworks
#

return if node.platform != "freebsd"

directory "/usr/local/etc/istgt" do
  action :create
end

package "istgt" do
  source "ports"
  action :install
end

service "istgt" do
  action :enable
end


template "/usr/local/etc/istgt/istgt.conf" do
  action :nothing
  source "istgt.conf"
  owner  "root"
  group  "wheel"
  mode   "0644"
  variables :portals => {}, :initiators => {}, :lunits => {}
  notifies :restart, resources(:service => "istgt")
end

template "/usr/local/etc/istgt/auth.conf" do
  action :nothing
  source "auth.conf"
  owner  "root"
  group  "wheel"
  mode   "0600"
  variables :groups => {}
end

# setting your PortalGroups, InitiatorGroups, LogicalUnits...
include_recipe "istgt::setting"

t = resources(:template => "/usr/local/etc/istgt/istgt.conf")
t.run_action(:create)
t = resources(:template => "/usr/local/etc/istgt/auth.conf")
t.run_action(:create)
