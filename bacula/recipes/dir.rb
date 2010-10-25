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

directory "#{node.bacula.dir.config_dir}/bacula-dir.conf.d" do
    owner  node.bacula.uid
    group  node.bacula.gid
    mode   0644
end

execute "create_bacula_dir_conf" do
    command "cat #{node.bacula.dir.config_dir}/bacula-dir.conf.d/* > #{node.bacula.dir.config_dir}/bacula-dir.conf"
    action :nothing
    notifies :restart, resources(:service => node.bacula.dir.service)
end

%w{
    dir.conf
    catalog.conf
    console.conf
    message.conf
    filesets.conf
    pool.conf
    schedule.conf
    jobdefs.conf
}.each do |f|
    template "#{node.bacula.dir.config_dir}/bacula-dir.conf.d/#{f}" do
        source "etc/bacula/bacula-dir.conf.d/#{f}"
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
            :console_password  => node.bacula.dir.console_password,
            :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
        })
        notifies :run, resources(:execute => "create_bacula_dir_conf")
    end
end

search(:node, "role:bacula_fd") do |n|
    bacula_client "#{n.hostname}-fd" do
        address getClientName(n.fqdn)
    end
end

# here, you can define clients manually via bacula_client()
include_recipe "bacula::myclients"

# default restore job
bacula_job "ResotreFiles" do
    job_type "Restore"
    fileset  "ClientStandardSet"
    storage  "TokyoClientFile"
    pool     "Default"
    messages "Standard"
    where    "/bacula-restores"
end

# here, you have to define jobs manually via bacula_job()
include_recipe "bacula::myjobs"

# ready to startup
#service node.bacula.dir.service do
#    action :start
#end
