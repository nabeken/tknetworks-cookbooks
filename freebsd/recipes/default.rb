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

ports_options "ports-mgmt/portmaster" do
  options %w{
    WITH_BASH=true
    WITH_ZSH=true
  }
  only_if do
    node.platform == "freebsd"
  end
end

%w{
  shells/bash
  shells/zsh
  sysutils/tmux
  net/rsync
  devel/git
  ports-mgmt/portmaster
}.each do |pkg|
  package pkg do
    source "ports"
  end
end
