include_recipe "postfix"

execute "newaliases" do
  command "newaliases"
end

template "#{node.postfix.config.dir}/main.cf" do
  source "loopback/main.cf"
  notifies :restart, "service[postfix]", :delayed
  mode 0644
end

template node.postfix.config.aliases do
  source "loopback/aliases"
  notifies :run, "execute[newaliases]", :immediately
end
