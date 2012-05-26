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

define :ssh_authorized_keys,
       :user    => nil,
       :path    => nil,
       :owner   => nil,
       :group   => nil,
       :options => [],
       :from    => nil,
       :key     => nil do
  raise "#{k} is required." if params[:key].nil?

  if params[:user].nil? && params[:path].nil?
    raise "user or path is required"
  end
  if params[:path]
    if params[:owner].nil? || params[:group].nil?
      raise "owner/group is required with params[:path]"
    end
  end

  if !params[:user].nil?
    f_owner = node[:etc][:passwd][params[:user]][:uid]
    f_group = node[:etc][:passwd][params[:user]][:gid]
    path    = "#{node[:etc][:passwd][params[:user].to_sym][:dir]}/.ssh/authorized_keys"
  else
    f_owner = params[:owner]
    f_group = params[:group]
    path    = params[:path]
  end

  t = nil
  directory ::File.dirname(path) do
    action :create
    owner f_owner
    group f_group
    mode  "0700"
  end

  begin
    t = resource("template[#{path}]")
  rescue
    t = template path do
          owner f_owner
          group f_group
          variables :lines => []
          cookbook "ssh"
          source "authorized_keys.erb"
        end
  end
  line = ""
  if !params[:from].nil?
    line += %Q[from="#{params[:from]}"]
  end
  if !params[:options].empty?
    line += ",#{params[:options].join(",")} "
  end
  line += params[:key].strip
  t.variables[:lines].push line
end
