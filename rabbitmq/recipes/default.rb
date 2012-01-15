#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2012, TKNetworks
#

package node[:rabbitmq][:package] do
  action :install
end

service node[:rabbitmq][:service] do
  action [:enable, :start]
  ignore_failure true
end
