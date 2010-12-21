service node.rsync.server.service do
  action :enable
end

begin
  include_recipe "rsync::#{node.hostname}"
rescue ArgumentError
  Chef::Log.info("failed to load rsync::#{node.hostname}")
end

service node.rsync.server.service do
  action :restart
end
