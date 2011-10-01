#
# Cookbook Name:: dbee
# Recipe:: default
#
# Copyright 2011, TKNetworks
#

include_recipe "stunnel"
include_recipe "debian"

# aptline
if node.platform == "debian"
  debian_aptline "debian_multimedia" do
    url node.dbee.aptline.url
    path node.dbee.aptline.path
    repo node.dbee.aptline.repo
  end
  package "debian-multimedia-keyring" do
    action :install
    options "--force-yes"
    notifies :run, "execute[apt-get-update]", :immediately
  end
end

# ruby stuffs
node.dbee.packages.each do |pkg|
  package pkg do
    action :install
  end
end

# package download
[node.dbee.ffmpeg_deb, node.dbee.x264_deb].each do |deb|
  execute "wget-#{File.basename(deb)}" do
    cwd "/usr/local/src"
    command "wget -q #{deb}"
    only_if do
      !File.exists?("/usr/local/src/#{File.basename(deb)}")
    end
  end
end

# ffmpeg deb
package "ffmpeg" do
  provider Chef::Provider::Package::Dpkg
  source "/usr/local/src/#{File.basename(node.dbee.ffmpeg_deb)}"
  action :install
  only_if do
    !File.exists?("/usr/local/bin/ffmpeg")
  end
end

# x264 deb
package "x264" do
  provider Chef::Provider::Package::Dpkg
  source "/usr/local/src/#{File.basename(node.dbee.x264_deb)}"
  action :install
  only_if do
    !File.exists?("/usr/local/bin/x264")
  end
end

# gem
gem_package "bundler" do
  gem_binary "gem1.9.1"
  action :install
end

git "dbee-release" do
  repository "git://github.com/nabeken/dbee.git"
  destination node.dbee.dir
  reference "next"
  action :sync
end

execute "git-submodule-init" do
  cwd node.dbee.dir
  command "git submodule init; git submodule update"
end

execute "#{node.dbee.gem_dir}/bin/bundle" do
  cwd node.dbee.dir
end

# config
template "#{node.dbee.dir}/config.rb" do
  source "config.rb"
  notifies :run,
    %w{
      execute[dbee-worker-terminate]
      execute[dbee-worker-start]
    },
    :immediately
  mode 0640
  variables :rake             => node.dbee.rake,
            :api_url          => node.dbee.api_url,
            :material_baseurl => node.dbee.material_baseurl,
            :http_user        => node.dbee.http_user,
            :http_password    => node.dbee.http_password,
            :ca_dir           => node.dbee.ca_dir,
            :dav_baseurl      => node.dbee.dav_baseurl,
            :output_dir       => node.dbee.output_dir
end

# god
execute "dbee-worker-start" do
  command "#{node.dbee.gem_dir}/bin/god -c #{node.dbee.dir}/god/worker.god"
end

execute "dbee-worker-terminate" do
  command "#{node.dbee.gem_dir}/bin/god terminate && sleep 10"
  action :nothing
  ignore_failure true
end
