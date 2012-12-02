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

define :openbsd_interface,
       :inet    => nil,
       :inet6   => nil,
       :dhcp    => false,
       :tunnel  => nil,
       :inner   => nil,
       :config  => nil,
       :rdomain => 0,
       :tunneldomain => 0,
       :extra_commands => [] do

  Chef::Log.info params.inspect
  if node[:platform] != "openbsd"
    raise "openvpn_interface is only for OpenBSD"
  end

  if (not params[:name] =~ /^(gre|enc)/) && params[:inet].nil? && params[:inet6].nil?
    raise "ipv4 or ipv6 address required"
  end

  if params[:name] =~ /^gre/ && params[:inner].nil?
    raise "inner address required"
  end

  begin
    t = resources("template[/etc/hostname.#{params[:name]}")
  rescue
    t = template "/etc/hostname.#{params[:name]}" do
          owner "root"
          group node[:etc][:passwd][:root][:gid]
          mode  0640
          variables({
            :inet   => params[:inet],
            :inet6  => params[:inet6],
            :dhcp   => params[:dhcp],
            :inner  => params[:inner],
            :rdomain => params[:rdomain],
            :tunnel  => params[:tunnel],
            :config  => params[:config],
            :tunneldomain   => params[:tunneldomain],
            :extra_commands => params[:extra_commands]
          })
          source case params[:name]
                 when /^enc/
                   "hostname.enc.if"
                 else
                   "hostname.if"
                 end
        end
  end
end

define :openbsd_ike,
       :mode  => nil,
       :proto => nil,
       :from  => nil,
       :to    => nil,
       :peer  => 'any',
       :psk   => nil do

  if [:mode, :from, :to, :psk].any? { |k| params[k].nil? }
    raise "mode, from, to, psk is required"
  end

  unless %w{passive active dynamic}.any? { |k| params[:mode] == k }
    raise "mode must be 'passive', 'active', or 'dynamic'"
  end

  t = nil
  begin
    t = resources("template[/etc/ipsec_chef.conf]")
  rescue
    t = template "/etc/ipsec_chef.conf" do
          owner "root"
          group node[:etc][:passwd][:root][:gid]
          mode  0600
          variables(
            :rules => []
          )
          source "ipsec_chef.conf"
        end
  end
  t.variables[:rules].push params
end

define :openbsd_ipsec do
  unless %w{passive active dynamic}.any? { |k| params[:name] == k }
    raise "name must be 'passive', 'active', or 'dynamic'"
  end

  # retrieve IPsec configurations from databag
  begin
    ipsec_conf = data_bag_item("ipsec", node[:openbsd][:ipsec][:gw_hostname]).find_all { |e|
      e.first != "id"
    }
    ipsec_conf.each do |conf|
      my, remote = conf.last.partition { |k, v| k == node[:fqdn] }.map { |c| c.flatten }

      # 自分が含まれていない場合は飛ばす
      if my.empty?
        Chef::Log.info "#{node[:fqdn]} is not found. skipped."
        next
      end
      if remote.empty?
        raise "something seems to be wrong."
      end
      my_gre = get_gre(my.last)
      my_lo = get_loopback(my.last)
      remote_gre = get_gre(remote.last)
      remote_lo = get_loopback(remote.last)
      has_rdomain = my.last.has_key?("rdomain")

      Chef::Log.info "configuring #{my.first} -> #{remote.first}"

      ipsec_mode = params[:name]
      mypeer = params[:peer]
      openbsd_interface my_lo.first do
        rdomain my.last["rdomain"] if has_rdomain
        inet "#{my_lo.last}/32"
      end
      openbsd_interface my_gre.first do
        tunneldomain my.last["rdomain"] if has_rdomain
        tunnel "#{my_lo.last} #{remote_lo.last}"
        inner "#{my_gre.last} #{remote_gre.last} netmask 255.255.255.255"
      end
      openbsd_ike "#{my.first} -> #{remote.first}" do
        mode  ipsec_mode
        proto "gre"
        from  "#{my_lo.last}/32"
        to    "#{remote_lo.last}/32"
        psk   node[:openbsd][:ipsec][:psk]
        peer  mypeer
      end
    end
  rescue => e
    Chef::Log.info("Could not load data bag 'ipsec', #{node[:hostname]}, this is optional, moving on... reason: #{e}")
  end
end
