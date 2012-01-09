#
# Cookbook Name:: freebsd
# Recipe:: default
#
# Copyright 2010, TKNetworks
#

cron "portsnap" do
  command "/usr/sbin/portsnap cron update"
  hour 3
  minute 0
  not_if do
    node[:virtualization][:system] == "jail" and node[:virtualization][:role] == "guest"
  end
end

package "shells/bash" do
  source "ports"
end
