#
# Cookbook Name:: postgresql
# Attributes:: postgresql
#
# Copyright 2008-2009, Opscode, Inc.
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

default[:postgresql][:ssl] = false

case platform
when "debian"

  if platform_version.to_f == 5.0
    default[:postgresql][:version] = "8.3"
  elsif platform_version =~ /squeeze/
    default[:postgresql][:version] = "8.4"
  end

  default[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  default[:postgresql][:service] = "postgresql"

when "freebsd"

  default[:postgresql][:version] = "9.1"
  default[:postgresql][:dir] = "/usr/local/pgsql/data"
  default[:postgresql][:service] = "postgresql"

end
