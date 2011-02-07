if node.platform == "gentoo"
  portage_use node.dovecot.pkg do
    enable %w(managesieve sieve)
  end
  portage_use "mail-mta/postfix" do
    enable %w(dovecot-sasl)
  end
end

package node.dovecot.pkg do
  action :install
end

service "dovecot" do
  action :enable
end

template "#{node.dovecot.config}/dovecot.conf" do
  owner "root"
  group "root"
  source "dovecot.conf"
  notifies :restart, resources(:service => "dovecot")
end

template "#{node.dovecot.config}/default.sieve" do
  owner  "root"
  group  "mailuser"
  source "default.sieve"
end

service "dovecot" do
  action :start
end
