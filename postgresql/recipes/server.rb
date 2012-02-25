# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Author:: Ken-ichi TANABE  (<nabeken@tknetworks.org>)
# Copyright 2009-2011, Opscode, Inc.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "postgresql"

# randomly generate postgres password
node.set_unless[:postgresql][:password][:postgres] = secure_password
node.save unless Chef::Config[:solo]

package node[:postgresql][:server][:package] do
  action :install
  source "ports" if node[:platform] == "freebsd"
end

service node[:postgresql][:service] do
  action :enable
  pattern "postgres"
end

execute "postgresql-initdb" do
  command node[:postgresql][:server][:initdb_cmd]
  only_if do
    case node[:platform]
    when "freebsd"
      !File.exists?("#{node[:postgresql][:dir]}/PG_VERSION")
    else
      false
    end
  end
end

begin
  resources("template[#{node[:postgresql][:dir]}/pg_hba.conf]")
rescue
  template "#{node[:postgresql][:dir]}/pg_hba.conf" do
    owner node[:postgresql][:uid]
    group node[:postgresql][:gid]
    mode  0600
    variables(
      :records => []
    )
    cookbook "postgresql"
    source "pg_hba.conf.erb"
    notifies :restart, "service[#{node[:postgresql][:service]}]"
  end
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "postgresql.conf.erb"
  owner node[:postgresql][:uid]
  group node[:postgresql][:gid]
  mode  0600
  notifies :restart, "service[#{node[:postgresql][:service]}]"
end

service node[:postgresql][:service] do
  action  :start
  pattern "postgres"
end
