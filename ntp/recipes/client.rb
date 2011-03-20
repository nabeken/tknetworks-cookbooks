include_recipe "ntp"

template node.ntp.config do
  source "ntp.conf"
  owner  "root"
  group  node.ntp.gid
  mode   "0644"
  variables :servers => node.ntp.client.servers
  notifies :restart, resources(:service => node.ntp.service)
end
