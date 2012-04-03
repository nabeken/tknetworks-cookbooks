#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

# In FreeBSD set DEFAULT_PGSQL_VER=91
e = execute "postgresql-set-default-vgsql-ver" do
  command "echo DEFAULT_PGSQL_VER=#{node[:postgresql][:version].gsub(/\./, "")}" +
          " >> /etc/make.conf"
  only_if do
    node[:platform] == "freebsd" &&
    !File.open('/etc/make.conf').readlines.any? { |l|
      l.start_with?("DEFAULT_PGSQL_VER=")
    }
  end
end
e.run_action(:run) if node[:platform] == "freebsd"
