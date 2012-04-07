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

# pinning gitolite from squeeze-backports
if node[:platform] == "debian"
  debian_pinning "gitolite" do
    pin "release squeeze-backports"
    priority 500
  end
end

package node[:gitolite][:package] do
  action :install
  options "-t #{node[:debian][:release]}-backports" if node[:platform] == "debian"
end

user node[:gitolite][:gitolite_user] do
  action [:create, :unlock]
  password '*'
  manage_home true
  home node[:gitolite][:gitolite_home]
end

directory node[:gitolite][:gitolite_home] do
  owner node[:gitolite][:gitolite_user]
  group node[:gitolite][:gitolite_user]
  mode 0700
end

pub_key = "#{node[:gitolite][:gitolite_home]}/#{node[:gitolite][:admin_name]}.pub"

file pub_key do
  owner "git"
  group "git"
  mode 0600
  content node[:gitolite][:admin_pubkey]
  notifies :run, "execute[gitolite-gl-setup]"
end

execute "gitolite-gl-setup" do
  action :nothing
  command "sudo -u #{node[:gitolite][:gitolite_user]} gl-setup -q #{pub_key}"
end
