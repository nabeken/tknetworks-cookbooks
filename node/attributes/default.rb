begin
  include_attribute "node::#{hostname}"
rescue
  Chef::Log.inf("failed to load attribute node::#{hostname}")
end
