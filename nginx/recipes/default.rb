#
# Cookbook Name:: nginx
# Recipe:: default
# Author:: AJ Christensen  <aj@junglist.gen.nz>
# Author:: Ken-ichi TANABE <nabeken@tknetworks.org>
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ports_options "nginx" do
  options node[:nginx][:options]
  only_if do
    node.platform == "freebsd"
  end
  notifies :install, "package[#{node[:nginx][:package]}]", :immediately
end

if node[:nginx][:passenger] == "on"
  ports_options "rubygem-passenger" do
    options %w{
      WITH_NGINXPORT=true
      WITHOUT_APACHEPORT=true
      WITHOUT_DEBUG=true
      WITHOUT_SYMLINK=true
    }
    only_if do
      node.platform == "freebsd"
    end
  end
  passenger = package "www/rubygem-passenger" do
    source "ports"
    only_if do
      node[:platform] == "freebsd"
    end
    notifies :create, "template[nginx.conf]", :immediately
  end
  # install gem immediately
  passenger.run_action(:install)
end

package node.nginx.package do
  action :install
  source "ports" if node.platform == "freebsd"
end

[
  "#{node[:nginx][:dir]}/sites-enabled/",
  "#{node[:nginx][:dir]}/sites-available/",
  "#{node[:nginx][:dir]}/conf.d/",
  "#{node[:nginx][:dir]}/ssl/",
  "#{node[:nginx][:log_dir]}",
  "/var/www"
].each do |dir|
  directory dir do
    mode 0755
    owner node[:nginx][:user]
    action :create
  end
end

%w{nxensite nxdissite}.each do |nxscript|
  template "#{node[:nginx][nxscript.to_sym]}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group node[:nginx][:gid]
  end
end

template "#{node[:nginx][:dir]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group node[:nginx][:gid]
  mode 0644
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group node[:nginx][:gid]
  mode 0644
  notifies :restart, "service[nginx]", :delayed
  if node[:nginx][:passenger] == "on"
    # avoid Errno::ENOENT when there is no passenger-config
    passenger_root = `passenger-config --root || :`.strip
    unless passenger_root.empty? && passenger_root.start_with?("/")
      variables :passenger_root => passenger_root
    end
  end
end

service "nginx" do
  supports :status => false, :restart => true, :reload => true
  action [ :enable, :start ]
  ignore_failure true
end
