include_recipe "nagios::client"

user "nagios" do
  home node.nagios.server.homedir
  supports :manage_home => true
  action [:create, :unlock]
  password '*'
end

package node.nagios.server.package do
  action :install
end

service node.nagios.server.service do
  action :enable
end

directory node.nagios.server.dir do
  owner node.nagios.server.uid
  group node.nagios.server.gid
  mode  0770
end

%w{
  hosts
  generics
}.each do |d|
  directory "#{node.nagios.server.dir}/#{d}" do
    owner node.nagios.server.uid
    group node.nagios.server.gid
    mode  0770
  end
end

%w{
  nagios.cfg
  resource.cfg
  conf.d/contacts_nagios2.cfg
  conf.d/hostgroups_nagios2.cfg
  conf.d/timeperiods_nagios2.cfg
}.each do |f|
  template "#{node.nagios.server.dir}/#{f}" do
    source "etc/nagios3/#{f}"
    owner node.nagios.server.uid
    group node.nagios.server.gid
    mode  0770
    variables :dir => node.nagios.server.dir
    notifies :restart, "service[#{node.nagios.server.service}]", :delayed
  end
end

template "#{node.nagios.server.dir}/htpasswd.users" do
  source "etc/nagios3/htpasswd.users"
  owner "root"
  group node.nagios.server.gid
  mode 0640
end

# 不要なファイルを削除する
%w{
  generic-host_nagios2.cfg
  generic-service_nagios2.cfg
  localhost_nagios2.cfg
  extinfo_nagios2.cfg
}.each do |f|
  fn = "#{node.nagios.server.dir}/conf.d/#{f}"
  file fn do
    action :delete
    only_if do
      File.exists?(fn)
    end
  end
end

extend Chef::Nagios

# sshのホストの公開鍵
ssh_pubkeys = {}

private_ipaddress_and_loopback = [
  /^10\./,
  /^172\.(?:1[6-9]|2\d|3[01])\./,
  /^192\.168\./,
  /^127\./
]

# roleベースでホストの自動設定
search(:node, "roles:nagios_client") do |s|
  nagios_host s.fqdn do
    use "generic-server"
  end

  # IPv4とIPv6アドレスを設定する
  Chef::Log.debug("node: #{s.fqdn}")

  s.network.interfaces.each do |int, props|
    Chef::Log.debug("interface: #{int}, props: #{props.inspect}")
    next unless props.has_key?("addresses")
    props[:addresses].each do |addr, addr_props|
      Chef::Log.debug("addr: #{addr}, props: #{addr_props.inspect}")
      # プライベートIPv4アドレスとループバックは除外
      next if private_ipaddress_and_loopback.any? { |mask| mask.match(addr) }
      if addr_props[:family] == "inet" || (addr_props[:family] == "inet6" && addr_props[:scope] == "Global")
        ssh_pubkeys["#{s.fqdn},#{addr}"] = s[:keys][:ssh][:host_rsa_public]
      end
    end
  end
end

# sshのknown_hostsを構成
template "#{node.nagios.server.homedir}/.ssh/known_hosts" do
  source "known_hosts"
  owner node.nagios.server.uid
  group node.nagios.server.gid
  mode 0644
  variables :pubkeys => ssh_pubkeys
end

# roleベースでサービスの自動設定
nagios_service "ping" do
  use "generic-service"
  hostgroups node.nagios.server.hostgroups
  command "check_ping"
  args %(2000.0,50%, 2000.0,80%)
  description "Ping monitoring"
end

node.nagios.checkcommands.each do |name, chk|
  Chef::Log.debug("autoregistering checkcommands #{name} on #{node.hostname}")
  nagios_checkcommand name do
    command_line chk[:command]
  end
end

# roleベースでサービスを自動設定
# サービスロールに属する = 監視を希望する
# 1サービスロール = 1サービス監視
# デフォルトの引数で問題なければロールに入るだけでいい
# 引数を変えたいならargsを上書きする
# 同じサービスだが、複数の監視が欲しいなら
# その場合はそのロールを複数含んだロールを作る
search(:role, "name:nagios_service_*") do |role|
  search(:node, "roles:#{role.name}") do |n|
    Chef::Log.debug("autoregistering service #{role.name} on #{n.fqdn}")
    nagios_service role.name do
      use n.nagios.service[role.name][:use]
      host n.name
      command n.nagios.service[role.name][:command]

      if n.nagios.service[role.name][:args].nil?
        args n.nagios.service[role.name][:default_args]
      else
        args n.nagios.service[role.name][:args]
      end
    end
  end
end

# here, you can define nagios host, service, checkcommand via definitions
include_recipe "nagios::myhosts"
include_recipe "nagios::myservices"
include_recipe "nagios::mycheckcommands"
