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

portage_use "app-portage/layman" do
    enable %w(cvs git subversion)
    notifies :reinstall, resources(:package => "app-portage/layman")
end

# useful USE flags
portage_use "dev-vcs/git" do
  enable %w(subversion)
end

%w{
    /etc/make.conf.local
    /var/lib/layman/make.conf
}.each do |f|
    unless File.exist?(f)
        Chef::Log.info("touching #{f}")
        FileUtils.mkdir_p(File.dirname(f))
        FileUtils.touch(f)
    end
end

config = {
    :use        => node.gentoo.default_use,
    :keywords   => getKeywords(node),
    :chost      => getChost(node),
    :cflags     => getCflags(node),
    :makeopts   => getMakeopts(node),
    :portdir    => "/usr/portage",
    :features   => node.gentoo.features,
    :mirrors    => getMirrors(node),
    :sync       => getSync(node),
    :rsync_opts => node.gentoo.rsync_opts,
    :linguas    => node.gentoo.linguas,
    :license    => node.gentoo.license,
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
