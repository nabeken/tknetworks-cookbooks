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

# params[:name]は使わない
define :pg_hba,
       :ctype    => :local,
       :database => :sameuser,
       :user     => nil,
       :address  => nil,
       :auth_method => :ident do
  t = nil

  begin
    t = resources("template[#{node[:postgresql][:dir]}/pg_hba.conf]")
  rescue
    t = template "#{node[:postgresql][:dir]}/pg_hba.conf" do
          owner node[:postgresql][:uid]
          group node[:postgresql][:gid]
          mode  0600
          variables(
            :records => []
          )
          cookbook "postgresql"
          source "pg_hba.conf.erb"
          notifies :restart, "service[#{node[:postgresql][:service]}]"
        end
  end
  if params[:user].nil?
    raise "user name is required"
  end
  # local      database  user  auth-method  [auth-options]
  # host       database  user  CIDR-address  auth-method  [auth-options]
  # hostssl    database  user  CIDR-address  auth-method  [auth-options]
  # hostnossl  database  user  CIDR-address  auth-method  [auth-options]

  case params[:ctype]
  when :local
    t.variables[:records].push(
      :type     => params[:ctype],
      :database => params[:database],
      :user     => params[:user],
      :address  => "",
      :auth_method => params[:auth_method]
    )
  when :host, :hostssl, :hostnossl
    if params[:address].nil?
      # assume IPv4/IPv6 loopback only
      addresses = %w{127.0.0.1/32 ::1/128}
    else
      addresses = [params[:address]].flatten
    end
    addresses.each do |addr|
      t.variables[:records].push(
        :type     => params[:ctype],
        :database => params[:database],
        :user     => params[:user],
        :address  => addr,
        :auth_method => params[:auth_method]
      )
    end
  else
    raise "ctype must be local, host, hostssl or hostnossl"
  end
end

define :createuser,
       :createdb   => true,
       :createrole => false,
       :login      => true,
       :superuser  => false do
  args = {
    :createdb   => {true => "--createdb",   false => "--no-createdb"},
    :createrole => {true => "--createrole", false => "--no-createrole"},
    :login      => {true => "--login",      false => "--no-login"},
    :superuser  => {true => "--superuser",  false => "--no-superuser"},
  }
  cmd = "createuser"
  args.keys.each do |k|
    cmd += " #{args[k][params[k]]}"
  end

  execute "postgresql-createuser-#{params[:name]}" do
    user node[:postgresql][:uid]
    command "#{cmd} #{params[:name]}"
    not_if do
      `su #{node[:postgresql][:uid]} -c "echo \\"SELECT count(*) FROM pg_roles WHERE rolname = '#{params[:name]}';\\" | psql -A -t -U #{node[:postgresql][:uid]} postgres"`.strip == "1"
    end
  end
end

define :createdb, :user => nil do
  params[:user] = params[:name] if params[:user].nil?

  execute "postgresql-createdb-#{params[:name]}" do
    user params[:user]
    command "createdb #{params[:name]}"
    not_if do
      `su #{params[:user]} -c "echo \\"SELECT count(*) FROM pg_database WHERE datname = '#{params[:name]}';\\" | psql -A -t -U #{params[:user]} postgres"`.strip == "1"
    end
  end
end
