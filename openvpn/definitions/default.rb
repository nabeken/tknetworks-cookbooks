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
       :local_ip => nil,
       :port     => 1194,
       :proto    => "udp",
       :dev_type => "tun",
       :dev      => nil,
       :use_tls  => true,
       :ca       => nil,
       :cert     => nil,
       :key      => nil do
  if params[:local_ip].nil? || params[:dev].nil?
    raise "local_ip and dev are required"
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
            :secret => secret
          })
          source "server_openvpn.conf"
          #notifies :restart, "service[#{node[:openvpn][:service]}]"
        end
  end
end