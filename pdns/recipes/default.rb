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
include_recipe "postgresql::server"

if node[:platform] == "gentoo"
  portage_keywords node[:pdns][:package] do
    keyword "~amd64"
  end
end

if node[:platform] != "debian"
  package node[:pdns][:package] do
    action :install
  end
else
  pdns_deb = "/var/cache/apt/archives/#{::File.basename(node[:pdns][:deb_url])}"
  e = execute "pdns-wget-pdns-deb" do
    command "wget #{node[:pdns][:deb_url]} -P #{node[:debian][:deb_archives]}"
    notifies :install, "dpkg_package[pdns-static]"
    only_if do
      !::File.exists?(pdns_deb)
    end
  end
  e.run_action(:run)
  dpkg_package "pdns-static" do
    source pdns_deb
    action :install
  end
end

user "pdns" do
  system true
end

execute "pdns-add-flags" do
  command %Q[echo pdns_flags=\\"${pdns_flags} --daemon=yes\\" >> /etc/rc.conf]
  only_if do
    node[:platform] == "freebsd" &&
    !File.open('/etc/rc.conf').readlines.any? { |l|
      l.start_with?("pdns_flags=")
    }
  end
end

service "pdns" do
  action :enable
  notifies :run, "execute[pdns-add-flags]", :immediately
end

pg_hba "pdns-local" do
  ctype :local
  user "pdns"
  auth_method :ident
end

pg_hba "pdns-loopback" do
  ctype :host
  user "pdns"
  auth_method :trust
end

template "#{node.pdns.dir}/pdns.conf" do
  source "pdns.conf"
  owner  "root"
  group  "pdns"
  mode   "0660"
  notifies :restart, "service[pdns]"
end

sql_files = %W{
  pgsql-pdns.sql
  pgsql-pdns-dnssec.sql
}

sql_files.each do |sql|
  cookbook_file "#{node[:pdns][:dir]}/#{sql}" do
    source sql
    owner "pdns"
    group "pdns"
    mode  "0600"
  end
end

# createuser
createuser "pdns"

# createdb
createdb "pdns"

# create table
bash "pdns-init-database" do
  user "pdns"
  code <<-EOC
cat #{node[:pdns][:dir]}/{#{sql_files.join(",")}} | psql pdns
EOC
  only_if do
    `su pdns -c "echo '\\d' | psql -A -t -U pdns pdns | wc -l"`.strip == "1"
  end
end

service "pdns" do
  action :start
end
