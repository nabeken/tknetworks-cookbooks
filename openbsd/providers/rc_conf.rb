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

action :enable do
  if @is_absent
    # Add
    @flags[@new_resource.name] = @new_resource.flags
    # write
    write_rc_conf_local_chef
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.info("openbsd_rc_conf: #{@new_resource.name} is already enabled")
  end
end

action :disable do
  if !@is_absent
    # remove
    @flags.delete(@new_resource.name)
    Chef::Log.info "disable? #{@flags.inspect}"
    # write
    write_rc_conf_local_chef
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.info("openbsd_rc_conf: #{@new_resource.name} is already disabled")
  end
end

def load_current_resource
  raise "only for OpenBSD" if node[:platform] != "openbsd"
  @current_resource = Chef::Resource::OpenbsdPkgScript.new(@new_resource.name)

  @flags = {}
  if ::File.exists?(@new_resource.rc_conf_local_chef_path)
    ::File.open(@new_resource.rc_conf_local_chef_path).each_line do |l|
      if l.strip =~ /^(.*)_flags="(.*)"$/
        @flags[$1] = $2
      end
    end
  end
  @is_absent = !@flags.has_key?(@new_resource.name)
  Chef::Log.info "openbsd_rc_conf: is_absent? #{@is_absent}, #{@flags}"
  @current_resource
end

protected

def write_rc_conf_local_chef
  # 空の場合は空ファイルにする
  ::File.open(@new_resource.rc_conf_local_chef_path, "w") { |f|
    @flags.sort.each { |p, flag|
      f.puts %Q[#{p}_flags="#{flag}"]
    }
  }
end
