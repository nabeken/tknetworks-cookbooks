require "socket"

define :nagios_host, :use => nil, :address => nil, :host_alias => nil, :contact_groups => nil, :hostgroups => nil, :group => "hosts" do
  extend Chef::Nagios

  begin
    if params[:address].nil?
      begin
          address = Socket.getaddrinfo(params[:name], nil, Socket::AF_INET6).first[3]
      rescue
          address = Socket.getaddrinfo(params[:name], nil, Socket::AF_UNSPEC).first[3]
      end
    else
      address = params[:address]
    end
  rescue SocketError
    raise if params[:address].nil?
    address = params[:address]
  end

  t = nil
  begin
    t = resources(:template => "#{node.nagios.server.dir}/hosts/#{params[:group]}.cfg")
  rescue
    t = template "#{node.nagios.server.dir}/hosts/#{params[:group]}.cfg" do
          source "etc/nagios3/hosts.cfg"
          owner node.nagios.server.uid
          group node.nagios.server.gid
          mode  0770
          variables :hosts => {}
          notifies :restart, resources(:service => node.nagios.server.service)
    end
  end

  # run_stateに登録したホスト名を記録する
  node.run_state[:nagios_hosts] = [] if node.run_state[:nagios_hosts].nil?
  node.run_state[:nagios_hosts].push params[:name]

  use = params[:use].nil? ? node.nagios.server.use : params[:use]
  host_alias  = params[:host_alias]
  contact_groups = params[:contact_groups].nil? ? node.nagios.server.contact_groups : params[:contact_groups]
  hostgroups = params[:hostgroups].nil? ? getHostgroups(params[:name]) : params[:hostgroups]

  node.set[:nagios][:server][:myhosts] = Mash.new if node[:nagios][:server][:myhosts].nil?

  myhost = Mash.new
  myhost[:address] = address
  myhost[:host_alias] = host_alias
  myhost[:contact_groups] = contact_groups
  myhost[:hostgroups] = hostgroups
  myhost[:use] = use

  t.variables[:hosts][params[:name]] = myhost
  Chef::Log.info("registering nagios host #{params[:name]}")
end

define :nagios_generic, :config => nil, :group => "default", :generic_type => "host" do
  t = nil

  begin
    t = resources(:template => "#{node.nagios.server.dir}/generics/#{params[:group]}.cfg")
  rescue
    t = template "#{node.nagios.server.dir}/generics/#{params[:group]}.cfg" do
          source "etc/nagios3/generic.cfg"
          owner node.nagios.server.uid
          group node.nagios.server.gid
          mode  0770
          variables :generics => {}
          notifies :restart, resources(:service => node.nagios.server.service)
    end
  end

  t.variables[:generics][params[:name]] = Mash.new if t.variables[:generics][params[:name]].nil?
  t.variables[:generics][params[:name]][:config] = params[:config]
  t.variables[:generics][params[:name]][:type]   = params[:generic_type]
  Chef::Log.info("registering nagios generic #{params[:name]}")
end

define :nagios_service, :use => nil, :hostgroups => nil, :description => nil, :command => nil, :host => nil, :group => "services" do
  t = nil

  begin
    t = resources(:template => "#{node.nagios.server.dir}/services.cfg")
  rescue
    t = template "#{node.nagios.server.dir}/services.cfg" do
          source "etc/nagios3/services.cfg"
          owner node.nagios.server.uid
          group node.nagios.server.gid
          mode  0770
          variables :services => {}
          notifies :restart, resources(:service => node.nagios.server.service)
    end
  end

  # ホスト登録がない場合はエラーにしてスキップ (かつhostgroups指定がない)
  unless node.run_state[:nagios_hosts].include?(params[:host]) || !params[:hostgroups].nil?
    Chef::Log.error("#{params[:host]} is not registered as nagios host. skipped....")
    next
  end

  use  = params[:use].nil? ? node.nagios.server.use : params[:use]
  hostgroups = params[:hostgroups]
  description = params[:description].nil? ? params[:name].upcase : params[:description]

  myservice = Mash.new
  myservice[:host_name] = params[:host]
  myservice[:hostgroups] = hostgroups.nil? ? hostgroups : hostgroups.join(",")
  myservice[:use] = use
  myservice[:description] = description
  myservice[:command] = params[:command].kind_of?(Array) ? params[:command].join("!") : params[:command]

  t.variables[:services][params[:name]] = [] unless t.variables[:services].has_key?(params[:name])
  t.variables[:services][params[:name]].push myservice
  Chef::Log.info("registering nagios service #{params[:name]} on #{params[:host]}")
end

define :nagios_checkcommand, :command_line => nil do
  t = nil

  begin
    t = resources(:template => "#{node.nagios.server.dir}/checkcommands.cfg")
  rescue
    t = template "#{node.nagios.server.dir}/checkcommands.cfg" do
          source "etc/nagios3/checkcommands.cfg"
          owner node.nagios.server.uid
          group node.nagios.server.gid
          mode  0770
          variables :commands => {}
          notifies :restart, resources(:service => node.nagios.server.service)
    end
  end

  raise if params[:command_line].nil?

  t.variables[:commands][params[:name]] = params[:command_line] if t.variables[:commands][params[:name]].nil?
  Chef::Log.info("registering nagios check command #{params[:name]}")
end
