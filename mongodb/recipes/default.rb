#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2012, TKNetworks
#
ports_options "spidermonkey" do
  options %w{
    WITH_UTF8=true
  }
  only_if do
    node.platform == "freebsd"
  end
end

package node[:mongodb][:package] do
  action :install
  source "ports" if node[:platform] == "freebsd"
end

template node[:mongodb][:conf] do
  source "mongodb.conf"
  variables(
    use_http_interface: node[:mongodb][:use_http_interface],
    bind_ip:            node[:mongodb][:bind_ip]
  )
  notifies :restart, "service[#{node[:mongodb][:service]}]"
  mode 0664
end

service node[:mongodb][:service] do
  action [:enable, :start]
  ignore_failure true
end
