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
       :rdomain => 0,
       :tunneldomain => 0,
       :extra_commands => [] do

  if node[:platform] != "openbsd"
    raise "openvpn_interface is only for OpenBSD"
  end

  if params[:inet].nil? && params[:inet6].nil?
    raise "ipv4 or ipv6 address required"
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
            :rdomain => params[:rdomain],
            :tunneldomain   => params[:tunneldomain],
            :extra_commands => params[:extra_commands]
          })
          source "hostname.if"
        end
  end
end
