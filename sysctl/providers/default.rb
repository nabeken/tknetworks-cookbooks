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

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :enable do
  if @is_absent
    # Add
    l = "#{@new_resource.name}=#{@new_resource.value}"
    l += "\t# #{@new_resource.comment}" if @new_resource.comment
    @sysctl_lines.push l
    write_sysctl_conf
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.info("#{@new_resource.name} is already enabled")
  end
  set_value_immediately if @new_resource.immediately
end

action :disable do
  if !@is_absent
    # remove
    write_sysctl_conf
  end
end

def load_current_resource
  @current_resource = Chef::Resource::Sysctl.new(@new_resource.name)

  unless validate_sysctl_key
    raise ArgumentError, "#{@new_resource.name} is not avaliable on #{node[:platform]}"
  end

  @sysctl_lines = []

  if ::File.exists?(@new_resource.sysctl_conf_path)
    ::File.open(@new_resource.sysctl_conf_path).each_line do |l|
      l.strip!
      if l =~ /^([^=]*)=(.*)$/
        if $1 == @new_resource.name
          @sysctl_val = $2
        end
      end
      # 操作対象以外はそのままにしておく
      @sysctl_lines.push l if @sysctl_val.nil?
    end
  end
  @is_absent = @sysctl_val.nil?
  @current_resource
end

protected

def write_sysctl_conf
  ::File.open(@new_resource.sysctl_conf_path, "w") do |f|
    @sysctl_lines.each do |l|
      f.puts l
    end
  end
end

def validate_sysctl_key
  result = shell_out("sysctl #{@new_resource.name}", :env => nil)
  if node[:platform] == "openbsd" && result.stderr =~ /is invalid$/
    false
  else
    result.status.success?
  end
end

def set_value_immediately
  Chef::Log.info "set value #{@new_resource.name}=#{@new_resource.value}."
  begin
    shell_out!("sysctl #{@new_resource.name}=#{@new_resource.value}", :env => nil)
  rescue => e
    raise "failed to set value #{@new_resource.name}=#{@new_resource.value}. #{e}"
  end
end
