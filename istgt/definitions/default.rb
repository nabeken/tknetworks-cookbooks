# name => PortalGroup1
define :istgt_portal, :addresses => nil do
  raise if params[:addresses].nil?
  t = resources(:template => "/usr/local/etc/istgt/istgt.conf")

  t.variables[:portals][params[:name]] = Mash.new if t.variables[:portals][params[:name]].nil?
  t.variables[:portals][params[:name]][:addresses] = params[:addresses]
end

# name => InitiatorGroup1
define :istgt_initiator, :initiators => nil do
  raise if params[:initiator_name].nil?
  t = resources(:template => "/usr/local/etc/istgt/istgt.conf")
  t.variables[:initiators][params[:name]] = Mash.new if t.variables[:initiators][params[:name]].nil?
  t.variables[:initiators][params[:name]][:initiators] = params[:initiators]
end

# name => LogicalUnit1
define :istgt_lunit, :target_name => nil, :mapping => nil, :auth_group => nil, :luns => nil do
  t = resources(:template => "/usr/local/etc/istgt/istgt.conf")
  t.variables[:lunits][params[:name]] = Mash.new if t.variables[:lunits][params[:name]].nil?
  t.variables[:lunits][params[:name]][:target_name] = params[:target_name]
  t.variables[:lunits][params[:name]][:mapping]     = params[:mapping]
  t.variables[:lunits][params[:name]][:auth_group]  = params[:auth_group]
  t.variables[:lunits][params[:name]][:luns]        = params[:luns]
end

# name => AuthGroup1
define :istgt_auth, :initiator_name => nil, :secret => nil, :mutualuser => nil, :mutualsecret => nil, :comment => nil do
  raise if params[:initiator_name].nil? || params[:secret].nil?
  t = resources(:template => "/usr/local/etc/istgt/auth.conf")
  t.variables[:groups][params[:name]] = Mash.new if t.variables[:groups][params[:name]].nil?
  t.variables[:groups][params[:name]][:initiator_name] = params[:initiator_name]
  t.variables[:groups][params[:name]][:secret]         = params[:secret]
  t.variables[:groups][params[:name]][:mutualuser]     = params[:mutualuser]
  t.variables[:groups][params[:name]][:mutualsecret]   = params[:mutualsecret]
  t.variables[:groups][params[:name]][:comment]        = params[:comment]
end
