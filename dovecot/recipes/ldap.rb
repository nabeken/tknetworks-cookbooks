package node.dovecot.pkg do
  action :install
end

template "#{node.dovecot.config}/dovecot-ldap.conf" do
  owner "root"
  group "root"
  mode  "0600"
  source "dovecot-ldap.conf"
end
