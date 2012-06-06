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

if node[:platform] == "freebsd"
  ports_options "nginx" do
    options node[:nginx][:options]
    notifies :install, "package[#{node[:nginx][:package]}]", :immediately
  end
end

if node[:nginx][:passenger] == "on"
  case node[:platform]
  when "freebsd"
    ports_options "rubygem-passenger" do
      options %w{
        WITH_NGINXPORT=true
        WITHOUT_APACHEPORT=true
        WITHOUT_DEBUG=true
        WITHOUT_SYMLINK=true
      }
    end
    passenger = package "www/rubygem-passenger" do
      source "ports"
      notifies :create, "template[nginx.conf]", :immediately
    end
    # install gem immediately
    passenger.run_action(:install)

    package node[:nginx][:package] do
      action :install
      source "ports"
    end

  when "debian"
    package "ruby-passenger" do
      action :install
    end

    # install nginx-passenger not nginx
    package "nginx-passenger" do
      action :install
      notifies :create, "template[nginx.conf]"
    end

  else
    package node[:nginx][:package] do
      action :install
      source "ports"
    end
  end

else
  package node[:nginx][:package] do
    action :install
    source "ports"
  end
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
    if node[:nginx][:passenger_root].respond_to?(:call)
      variables :passenger_root => node[:nginx][:passenger_root].call,
                :passenger_ruby => node[:nginx][:passenger_ruby]
    else
      variables :passenger_root => node[:nginx][:passenger_root],
                :passenger_ruby => node[:nginx][:passenger_ruby]
    end
  end
end

service "nginx" do
  supports :status => false, :restart => true, :reload => true
  action [ :enable, :start ]
  ignore_failure true
end
