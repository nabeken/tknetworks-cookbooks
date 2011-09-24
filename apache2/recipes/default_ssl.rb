include_recipe "apache2"

default_ssl = "#{node.apache2.config.dir}/sites-enabled/default-ssl"

template default_ssl do
  source "default-ssl"
  variables :cert => node.apache2.config.cert,
            :cert_key => node.apache2.config.cert_key
  mode 0644
  notifies :restart, "service[#{node.apache2.service}]", :delayed
end

[node.apache2.config.cert, node.apache2.config.cert_key].each do |c|
  file c do
    group node.apache2.gid
  end
end

link "#{node.apache2.config.dir}/sites-available/default-ssl" do
  to "#{node.apache2.config.dir}/sites-enabled/default-ssl"
  notifies :restart, "service[#{node.apache2.service}]", :delayed
end

execute "a2enmod ssl" do
  command "/usr/sbin/a2enmod ssl"
  notifies :restart, "service[#{node.apache2.service}]", :delayed
  only_if do
    !::File.exists?("#{node.apache2.config.dir}/mods-enabled/ssl.conf") ||
    !::File.exists?("#{node.apache2.config.dir}/mods-enabled/ssl.load")
  end
end

execute "a2dissite default" do
  command "/usr/sbin/a2dissite default"
  notifies :restart, "service[#{node.apache2.service}]", :delayed
  only_if do
    node.apache2.default_ssl_only &&
    File.exists?("#{node.apache2.config.dir}/sites-enabled/default")
  end
end
