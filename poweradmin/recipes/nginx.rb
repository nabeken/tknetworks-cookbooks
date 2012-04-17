#
# Cookbook Name:: poweradmin
# Recipe:: default
#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
#
# Copyright 2012, TANABE Ken-ichi
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

include_recipe "php::fpm"
include_recipe "nginx"
include_recipe "poweradmin"

nginx_site node[:poweradmin][:vhost] do
  use_php_fpm true
  use_https   true
  create_htdocs false
end

# basic認証のファイル
template "#{node[:nginx][:dir]}/poweradmin.htpasswd" do
  source "poweradmin.htpasswd"
  owner node[:nginx][:user]
  group node[:nginx][:gid]
  mode 0600
end

# nginxのセットアップ
template "/var/www/#{node[:poweradmin][:vhost]}/nginx.conf" do
  source "nginx.conf"
  owner node[:nginx][:user]
  group node[:nginx][:gid]
  notifies :restart, "service[nginx]"
end

# htdocsをpoweradminへ向ける
link "/var/www/#{node[:poweradmin][:vhost]}/htdocs" do
  action :create
  to node[:poweradmin][:install_dir]
end
