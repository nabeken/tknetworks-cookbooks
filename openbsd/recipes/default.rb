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

return if node[:platform] != "openbsd"

execute "openbsd-add-manip-pkg-script" do
  oneliner = "[ -f /etc/pkg_scripts ] && for _r in `cat #{node[:openbsd][:pkg_scripts]}`; do pkg_scripts=\"${pkg_scripts} ${_r}\"; done"
  rc = "/etc/rc.conf.local"
  command "echo >> #{rc}; echo \"# DO NOT APPEND ANY LINES BELOW\" >> #{rc}; echo '#{oneliner}' >> #{rc}"
  not_if do
    ::File.open("/etc/rc.conf.local").readlines.any? { |l|
      l.start_with?(oneliner)
    }
  end
end
