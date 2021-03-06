return if node[:platform] != "debian"

execute "apt-get-update" do
  command "/usr/bin/apt-get -q update"
  action :nothing
end

debian_aptline "security" do
  url  "http://security.debian.org/"
  path "/updates"
  repo %w{main contrib}
end

debian_aptline "base" do
  url  "http://cdn.debian.net/debian"
  repo %w{main contrib non-free}
end

# opscode's cool repos
debian_aptline "opscode" do
  url  "http://apt.opscode.com"
  repo %w{main}
  release "#{node[:debian][:release]}-0.10"
end

# remove execute bits
file "/etc/cron.daily/find" do
  mode 0444
end

%w{
  cron-apt
  rsync
  strace
  zsh
  less
  lv
  git-core
  vim
}.each do |pkg|
  package pkg do
    action :install
  end
end

cookbook_file "/etc/cron-apt/config" do
  source "etc/cron-apt/config"
  owner "root"
  group "root"
  mode  0644
end
