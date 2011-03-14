# default recipes
#
# package, service, config
#

package node.bacula.fd.package do
    action :install
end

service node.bacula.fd.service do
    action :enable
end

dir_host = search(:node, "role:bacula_dir")

template node.bacula.fd.config do
    source "bacula-fd.conf"
    owner  "bacula"
    group  "bacula"
    mode   0644
    variables({
        :dir_hostname => dir_host.first.hostname,
        :password     => node.bacula.password,
        :dir          => node.bacula.dir,
        :tls          => node.bacula.tls,
        :working_dir  => node.bacula.working_dir,
        :pid_dir      => node.bacula.pid_dir,
        :hostname     => node.hostname,
        :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
    })
    notifies :restart, resources(:service => node.bacula.fd.service)
end

if node.platform == "freebsd"
  link "/usr/local/etc/bacula-fd.conf" do
    to "/usr/local/etc/bacula/bacula-fd.conf"
  end
else
  link "/usr/local/etc/bacula" do
    to "/etc/bacula"
  end
end

# ready to startup
service node.bacula.fd.service do
    action :start
end
