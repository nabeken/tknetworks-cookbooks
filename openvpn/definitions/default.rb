#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
define :openvpn_server,
       :local_ip  => nil,
       :port      => 1194,
       :proto     => "udp",
       :dev_type  => "tap",
       :dev_index => 0,
       :use_tls   => true,
       :ca        => nil,
       :cert      => nil,
       :key       => nil do
  if params[:local_ip].nil? || params[:dev_index].nil?
    raise "local_ip and dev_index are required"
  end

  is_key_nil = [:ca, :cert, :key].any? { |n| params[n].nil?  }
  if params[:use_tls] && is_key_nil
    raise "ca, cert, key are required."
  end

  if !params[:use_tls]
    # retrive secret key from encryped databag
    ovpn_databag = Chef::EncryptedDataBagItem.load('openvpn', params[:name])
    secret = "#{node[:openvpn][:dir]}/#{params[:name]}.key"
    file secret do
      owner node[:openvpn][:uid]
      group node[:openvpn][:gid]
      mode  0600
      content ovpn_databag["key"]
      backup false
    end
  end

  devname = case node[:platform]
            when "openbsd"
              "tun#{params[:dev_index]}"
            else
              "#{params[:dev_type]}#{params[:dev_index]}"
            end

  begin
    t = resources("template[#{node[:openvpn][:dir]}/#{params[:name]}.conf]")
  rescue
    t = template "#{node[:openvpn][:dir]}/#{params[:name]}.conf" do
          owner node[:openvpn][:uid]
          group node[:openvpn][:gid]
          mode  0600
          cookbook "openvpn"
          variables({
            :params => params,
            :dev    => devname,
            :secret => secret
          })
          source "server_openvpn.conf"
          #notifies :restart, "service[#{node[:openvpn][:service]}]"
        end
  end
end

define :openvpn_client,
       :remote    => nil,
       :port      => 1194,
       :proto     => "udp",
       :dev_index => nil,
       :dev_type  => "tap",
       :dev       => nil,
       :ifconfig  => nil,
       :use_tls   => true,
       :ca        => nil,
       :cert      => nil,
       :key       => nil,
       :service   => true,
       :routes    => [] do
  if params[:remote].nil?
    raise "remote is required"
  end

  is_key_nil = [:ca, :cert, :key].any? { |n| params[n].nil?  }
  if params[:use_tls] && is_key_nil
    raise "ca, cert, key are required."
  end

  if !params[:use_tls]
    # retrive secret key from encryped databag
    ovpn_databag = Chef::EncryptedDataBagItem.load('openvpn', params[:name])
    secret = "#{node[:openvpn][:dir]}/#{params[:name]}.key"
    file secret do
      owner node[:openvpn][:uid]
      group node[:openvpn][:gid]
      mode  0600
      content ovpn_databag["key"]
      backup false
    end
  end

  # retrive a parameter for ifconfig from databag
  if params[:ifconfig] == :databag
    ifconfig = data_bag_item('openvpn', "ifconfig_#{params[:name]}")[node[:fqdn]]
  else
    ifconfig = params[:ifconfig]
  end

  # merge routes from params[:routes] and databag
  routes = []
  begin
    ovpn_routes = data_bag_item('openvpn', 'routes')
    if ovpn_routes.has_key?(params[:name])
      routes += params[:routes] + ovpn_routes[params[:name]]
    end
  rescue Net::HTTPServerException
    Chef::Log.info("routes for #{params[:name]} is not found.")
    routes += params[:routes]
  end

  if !params[:dev_index].nil?
    devname = case node[:platform]
              when "openbsd"
                "tun#{params[:dev_index]}"
              else
                "#{params[:dev_type]}#{params[:dev_index]}"
              end
  end

  config = "#{node[:openvpn][:dir]}/#{params[:name]}_client.conf"
  begin
    t = resources("template[#{config}]")
  rescue
    t = template config do
          owner node[:openvpn][:uid]
          group node[:openvpn][:gid]
          mode  0600
          cookbook "openvpn"
          variables({
            :params   => params,
            :secret   => secret,
            :ifconfig => ifconfig,
            :dev      => devname,
            :routes   => routes
          })
          source "client_openvpn.conf"
          #notifies :restart, "service[#{node[:openvpn][:service]}]"
        end
  end
  if node[:platform] =~ /^(free|open)bsd/
    prefix = node[:platform] == "freebsd" ? "/usr/local" : ""
    link "#{prefix}/etc/rc.d/openvpn_#{params[:name]}_client" do
      to "#{prefix}/etc/rc.d/openvpn"
    end
  end

  # registering service
  if params[:service]
    case node[:platform]
    when "openbsd"
      openbsd_pkg_script "openvpn_#{params[:name]}_client" do
        action [:enable, :start]
      end
    when "freebsd"
      link "#{node[:openvpn][:dir]}/openvpn_#{params[:name]}_client.conf" do
        to config
      end
      execute "openvpn-freebsd-add-#{params[:name]}_client_if" do
        oneliner = "openvpn_#{params[:name]}_client_if=\"tap\""
        command "echo '#{oneliner}' >> /etc/rc.conf"
        not_if do
          ::File.open("/etc/rc.conf").readlines.any? { |l|
            l.start_with?(oneliner)
          }
        end
      end
      service "openvpn_#{params[:name]}_client" do
        action :enable
      end
      service "openvpn_#{params[:name]}_client" do
        action :start
        ignore_failure true
      end
    else
      service node[:openvpn][:service] do
        action [:enable, :start]
      end
    end
  end
end
