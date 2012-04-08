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

# must be set via roles
default[:gitolite][:admin_name] = "root"
default[:gitolite][:admin_pubkey] = "key"

default[:gitolite][:gitolite_user] = "git"
default[:gitolite][:gitolite_home] = "/var/lib/gitolite"

case platform
when "gentoo"
  default[:gitolite][:package] = "dev-vcs/gitolite"
else
  default[:gitolite][:package] = "gitolite"
end