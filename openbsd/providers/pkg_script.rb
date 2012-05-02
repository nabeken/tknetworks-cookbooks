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
    @pkgs.push(@new_resource.name)
    @pkgs.uniq!
    # write
    write_pkg_scripts
    @new_resource.updated_by_last_action(true)
  else
    Chef::Log.info("#{@new_resource.name} is already enabled")
  end
end

action :disable do
  if !@is_absent
    # remove
    @pkgs.delete(@new_resource.name)
    @pkgs.uniq!
    # write
    write_pkg_scripts
    @new_resource.updated_by_last_action(true)
  end
end

action :start do
  result = shell_out!("/etc/rc.d/#{@new_resource.name} start", :env => nil)
  result.error!
end

def load_current_resource
  raise "only for OpenBSD" if node[:platform] != "openbsd"
  @current_resource = Chef::Resource::OpenbsdPkgScript.new(@new_resource.name)

  if ::File.exists?(@new_resource.pkg_scripts_path)
    @pkgs = ::File.open(@new_resource.pkg_scripts_path).read.strip.split(/[\s\n]/)
  else
    @pkgs = []
  end
  @is_absent = !@pkgs.include?(@new_resource.name)
  @current_resource
end

protected

def write_pkg_scripts
  if !@pkgs.empty?
    ::File.open(@new_resource.pkg_scripts_path, "w") { |f|
      f.write @pkgs.join("\n") + "\n"
    }
  end
end
