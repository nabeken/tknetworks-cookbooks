#
# Cookbook Name:: bacula
# Recipe:: default
#

user node.bacula.uid
group node.bacula.gid

if node.platform == "freebsd"
  package "shells/bash" do
    action :install
  end
end
