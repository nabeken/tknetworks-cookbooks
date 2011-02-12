if node.platform == "gentoo"
  portage_keywords node.pdns.package do
    keyword "~amd64"
  end
end

package node.pdns.package do
  action :install
end

service "pdns" do
  action :enable
end

template node.pdns.config.file do
  source "pdns.conf"
  owner "root"
  group "pdns"
  mode "0660"
  variables :db_host => node.pdns.config.db_host,
            :db_user => node.pdns.config.db_user,
            :db_name => node.pdns.config.db_name,
            :db_password => node.pdns.config.db_password,
            :axfr_ips => node.pdns.config.axfr_ips,
            :bind     => node.pdns.config.bind
  notifies :restart, resources(:service => "pdns")
end

service "pdns" do
  action :start
end
