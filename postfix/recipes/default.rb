#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2011, TKNetworks
#

package "exim4" do
  action :remove
  only_if do
    node[:platform] == "debian"
  end
end

package "postfix" do
  action :install
  source "ports" if node[:platform] == "freebsd"
end

service "postfix" do
  action [:enable, :start]
  ignore_failure true
end

service "sendmail" do
  action :disable
end

service "sendmail" do
  action :stop
  ignore_failure true
end

#if node[:platform] == "freebsd"
#  %w{
#    sendmail_submit
#    sendmail_outbound
#    sendmail_msp_queue
#  }.each do |srv|
#    service srv do
#      action :disable
#    end
#  end
#end

file "/etc/mailname" do
  content node[:postfix][:config][:myorigin]
  notifies :restart, "service[postfix]", :delayed
end
