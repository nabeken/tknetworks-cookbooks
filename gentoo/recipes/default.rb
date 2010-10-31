#
# Cookbook Name:: gentoo
# Recipe:: default
#

return if node.platform != "gentoo"

require "fileutils"
extend Chef::Gentoo

arch = getKeywords(node)

link "/etc/make.profile" do
    to "/usr/portage/profiles/default/linux/#{arch}/#{node.gentoo.release}/#{node.gentoo.profile}"
end

package "app-portage/layman" do
    action :install
end

unless File.exist?("/etc/make.conf.local")
    Chef::Log.info("touching /etc/make.conf.local")
    FileUtils.touch("/etc/make.conf.local")
end

config = {
    :use      => node.gentoo.default_use,
    :keywords => getKeywords(node),
    :chost    => getChost(node),
    :cflags   => getCflags(node),
    :makeopts => getMakeopts(node),
    :portdir  => "/usr/portage",
    :features => node.gentoo.features,
    :mirrors  => getMirrors(node),
    :sync     => getSync(node),
    :linguas  => node.gentoo.linguas,
    :license  => node.gentoo.license,
    :apache2_modules => node.gentoo.apache2_modules,
    :portdir_overlay => "/usr/local/portage"
}

template "/etc/make.conf" do
    source "etc/make.conf"
    owner "root"
    group "root"
    mode  0644
    variables :config => config
end

template "/etc/make.conf.use" do
    source "etc/make.conf.use"
    owner "root"
    group "root"
    mode  0644
    variables :use => node.gentoo.use
end
