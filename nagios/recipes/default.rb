#
# Cookbook Name:: nagios
# Recipe:: default
#
# Copyright 2010, TKNetworks
#
# All rights reserved - Do Not Redistribute
#
#

link "/usr/local/lib/nagios" do
    to node.nagios.real_user1
end
