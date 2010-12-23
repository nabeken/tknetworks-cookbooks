service node.rsync.server.service do
  action :enable
  running true
end

begin
  include_recipe "rsync::#{node.hostname}"
rescue ArgumentError
  Chef::Log.info("failed to load rsync::#{node.hostname}")
end
