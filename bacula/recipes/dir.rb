# default recipes
#
# package, service, config
#
#
# dir

extend Chef::Bacula

package node.bacula.dir.package do
    action :install
end

service node.bacula.dir.service do
    action :enable
end

dir_confs = %w{
    catalog.conf
    console.conf
    message.conf
    filesets.conf
    pool.conf
    schedule.conf
    jobdefs.conf
}

dir_confs.each do |f|
    template "#{node.bacula.dir.config_dir}/bacula-dir.conf.d/#{f}" do
        source "bacula-dir/#{f}"
        owner  node.bacula.uid
        group  node.bacula.gid
        mode   0644
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

template "#{node.bacula.dir.config_dir}/bacula-dir.conf" do
    source "bacula-dir.conf"
    owner  node.bacula.uid
    group  node.bacula.gid
    mode   0644
    variables({
        :dir_confs    => dir_confs,
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

search(:node, "role:bacula_fd") do |n|
    bacula_client "#{n.hostname}-fd" do
        address getClientName(n.fqdn)
    end
end

# here, you can define clients manually via bacula_client()
include_recipe "bacula::dir_myclients"

# default restore job
bacula_job "ResotreFiles" do
    job_type "Restore"
    fileset  "ClientStandardSet"
    storage  "TokyoClientFile"
    pool     "Default"
    messages "Standard"
    where    "/bacula-restores"
end

node.bacula.dir.jobs.each do |name, config|
    bacula_job name do
        default  config[:default]
        schedule config[:schedule]
        storage  config[:storage]
    end
end

# ready to startup
#service node.bacula.dir.service do
#    action :start
#end
