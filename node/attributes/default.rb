begin
  include_attribute "node::#{hostname}"
rescue Chef::Exceptions::AttributeNotFound
  Chef::Log.debug("failed to load attribute node::#{hostname}")
end
