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

include_recipe "pdns"

directory "#{node[:etc][:passwd][:pdns][:dir]}/.ssh" do
  action :create
  owner "pdns"
  group "pdns"
  mode 0700
end

ssh_keys = Chef::EncryptedDataBagItem.load('ssh_keys', 'pdns-backup')
file "#{node[:etc][:passwd][:pdns][:dir]}/.ssh/id_rsa" do
  mode 0600
  owner "pdns"
  group "pdns"
  content ssh_keys["key"]
  backup false
end

git "#{node[:etc][:passwd][:pdns][:dir]}/pdns-backup" do
  repository node[:pdns][:backup][:repository]
  reference "master"
  action :sync
  user "pdns"
  group "pdns"
end

cron "pdns-backup" do
  command "#{node[:etc][:passwd][:pdns][:dir]}/pdns-backup/bin/pdns-backup.sh"
  hour   5
  minute 30
  mailto node[:pdns][:backup][:mailto]
  user "pdns"
end
