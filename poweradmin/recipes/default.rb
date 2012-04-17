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
  repository node[:poweradmin][:git_repository]
  reference node[:poweradmin][:version]
  action :sync
end
