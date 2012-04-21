#
# Cookbook Name:: poweradmin
# Recipe:: default
#
# Copyright 2012, TANABE Ken-ichi
#

# 依存パッケージインストール
node[:poweradmin][:packages].each do |pkg|
  package pkg do
    action :install
    source "ports" if node[:platform] == "freebsd"
  end
end

# Gitから取得する
git node[:poweradmin][:install_dir] do
  user node[:nginx][:user]
  group node[:nginx][:gid]
  repository node[:poweradmin][:git_repository]
  reference node[:poweradmin][:version]
  action :sync
  not_if do
    ::File.exists?(node[:poweradmin][:install_dir])
  end
end

template "#{node[:poweradmin][:install_dir]}/inc/config.inc.php" do
  owner node[:nginx][:user]
  group node[:nginx][:gid]
  mode "0640"
  source "config.inc.php"
end
