package node.bacula.sd.package do
    action :install
end

service node.bacula.sd.service do
    action :enable
end

dir_host = search(:node, "role:bacula_dir")

template node.bacula.sd.config do
    source "bacula-sd.conf"
    owner  "bacula"
    group  "bacula"
    mode   0644
    variables({
        :devices      => {},
        :dir_hostname => dir_host.first.hostname,
        :tls          => node.bacula.tls,
        :password     => node.bacula.password,
        :dir          => node.bacula.dir,
        :working_dir  => node.bacula.working_dir,
        :pid_dir      => node.bacula.pid_dir,
        :hostname     => node.hostname,
        :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
    })
    notifies :restart, resources(:service => node.bacula.sd.service)
end

if node.platform == "freebsd"
  link "/usr/local/etc/bacula-sd.conf" do
    to "/usr/local/etc/bacula/bacula-sd.conf"
  end
end

node.bacula.sd.devices.each do |name, config|
    directory config[:device] do
        recursive true
        action    :create
        owner node.bacula.uid
        group node.bacula.gid
        mode 0740
    end
    bacula_sd_device name do
        device config[:device]
    end
end

# ready to startup
service node.bacula.sd.service do
    action :start
end
