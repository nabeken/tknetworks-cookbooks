extend Chef::Bacula

define :bacula_sd_device, :device => nil do
    t = resources(:template => "#{node.bacula.sd.config}")

    raise if params[:device].nil?

    t.variables[:devices][params[:name]] = Mash.new if t.variables[:devices][params[:name]].nil?
    t.variables[:devices][params[:name]][:device] = params[:device]
end

define :bacula_client, :address => nil do
    t = nil

    begin
	t = resources(:template => "#{node.bacula.config_dir}/bacula-dir.conf.d/client.conf")
    rescue
	t = template "#{node.bacula.config_dir}/bacula-dir.conf.d/client.conf" do
	    source "etc/bacula/bacula-dir.conf.d/client.conf"
	    owner node.bacula.uid
	    group node.bacula.gid
            mode  0644
	    variables :clients => {}, :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs, :tls => node.bacula.tls
            notifies :run, resources(:execute => "create_bacula_dir_conf")
	end
    end

    t.variables[:clients][params[:name]] = Mash.new if t.variables[:clients][params[:name]].nil?
    t.variables[:clients][params[:name]][:address] = params[:address]

    Chef::Log.info("registering bacula client #{params[:name]}")
end

define :bacula_job, :default => nil, :client => nil, :schedule => nil, :storage => nil, :fileset => nil, :pool => nil, :messages => nil, :where => nil, :job_type => nil do
    t = nil

    begin
	t = resources(:template => "#{node.bacula.config_dir}/bacula-dir.conf.d/job.conf")
    rescue
	t = template "#{node.bacula.config_dir}/bacula-dir.conf.d/job.conf" do
	    source "etc/bacula/bacula-dir.conf.d/job.conf"
	    owner node.bacula.uid
	    group node.bacula.gid
            mode  0644
	    variables :jobs => {}, :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
            notifies :run, resources(:execute => "create_bacula_dir_conf")
	end
    end

    t.variables[:jobs][params[:name]] = Mash.new if t.variables[:jobs][params[:name]].nil?

    [:client, :storage, :default, :schedule, :fileset, :pool, :messages, :pool].each do |para|
        t.variables[:jobs][params[:name]][para] = params[para]
    end

    Chef::Log.info("registering bacula job #{params[:name]}")
end
