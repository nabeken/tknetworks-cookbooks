#
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2011, TKNetworks
#

package "exim4" do
  action :remove
end

package "postfix" do
  action :install
end

service "postfix" do
  action :enable
end

case node.platform
when "debian"
  file "/etc/mailname" do
    content node.postfix.config.myorigin
    notifies :restart, "service[postfix]", :delayed
  end
end
