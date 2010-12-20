#
# Cookbook Name:: rsync
# Recipe:: default
#
# Copyright 2010, TKNetworks
#

package node.rsync.package do
  source "ports" if node.platform == "freebsd"
  action :install
end
