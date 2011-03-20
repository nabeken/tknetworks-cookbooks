#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2010, TKNetworks
#

# FreeBSD's base system includes ntpd
if node.platform != "freebsd"
  package node.ntp.pkg do
    action :install
  end
  if node.platform == "gentoo"
    portage_use node.ntp.pkg do
      enable %w(caps)
    end
  end
end

if node.platform == "debian"
  package "ntpdate" do
    action :install
  end
end

service node.ntp.service do
  action :enable
end
