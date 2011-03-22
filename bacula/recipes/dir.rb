# default recipes
#
# package, service, config
#
#
# dir


package node.bacula.dir.package do
    action :install
end

service node.bacula.dir.service do
    action :enable
end

directory "#{node.bacula.dir.config_dir}/bacula-dir.conf.d" do
  recursive  true
  action     :create
end

dir_conf_templates = %w{
    catalog.conf
    console.conf
    message.conf
    filesets.conf
    pool.conf
    schedule.conf
    jobdefs.conf
}

dir_conf_templates.each do |f|
    template "#{node.bacula.dir.config_dir}/bacula-dir.conf.d/#{f}" do
        source "bacula-dir/#{f}"
        owner  node.bacula.uid
        group  node.bacula.gid
        mode   0640
        variables({
            :dir_hostname => node.hostname,
            :tls          => node.bacula.tls,
            :working_dir  => node.bacula.working_dir,
            :pid_dir      => node.bacula.pid_dir,
            :conf_dir     => node.bacula.config_dir,
            :query_file   => node.bacula.dir.query_file,
            :console_password        => node.bacula.dir.console_password,
            :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
        })
        notifies :restart, resources(:service => node.bacula.dir.service)
    end
end

%w(bacula-dir.conf bconsole.conf).each do |f|
  template "#{node.bacula.dir.config_dir}/#{f}" do
      source f
      owner  node.bacula.uid
      group  node.bacula.gid
      mode   0640
      variables({
          :dir_confs    => node.bacula.dir.confs + dir_conf_templates,
          :dir_hostname => node.hostname,
          :tls          => node.bacula.tls,
          :working_dir  => node.bacula.working_dir,
          :pid_dir      => node.bacula.pid_dir,
          :conf_dir     => node.bacula.config_dir,
          :query_file   => node.bacula.dir.query_file,
          :console_password        => node.bacula.dir.console_password,
          :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
      })
      notifies :restart, resources(:service => node.bacula.dir.service)
  end

  if node.platform == "freebsd"
    link "/usr/local/etc/#{f}" do
      to "/usr/local/etc/bacula/#{f}"
    end
  end
end

search(:node, "role:bacula_fd") do |n|
    bacula_client "#{n.hostname}-fd" do
        extend Chef::Bacula
        address getClientName(n.fqdn)
    end
end

# here, you can define clients manually via bacula_client()
include_recipe "bacula::dir_myclients"

# default restore job
bacula_job "RestoreFiles" do
    job_type "Restore"
    fileset  "ClientStandardSet"
    storage  "TokyoClientFile"
    pool     "Default"
    messages "Standard"
    where    "/bacula-restores"
    client   "#{node.hostname}-fd"
end

node.bacula.dir.jobs.each do |name, config|
    bacula_job name do
        default  config[:default]
        schedule config[:schedule]
        storage  config[:storage]
        client   name
    end
end

node.bacula.dir.storage_resources.each do |name, res|
    bacula_storage name do
        hostname res[:hostname]
        device   res[:device]
    end
end

# ready to startup
service node.bacula.dir.service do
    action :start
end
