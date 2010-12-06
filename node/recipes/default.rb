begin
  include_recipe "node::#{node.hostname}"
rescue
  Chef::Log.info("failed to load node::#{node.hostname}")
end
