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
end
