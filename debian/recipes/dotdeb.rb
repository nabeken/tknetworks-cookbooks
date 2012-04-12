return if node[:platform] != "debian"

include_recipe "debian"

debian_aptline "dotdeb" do
  url     "http://packages.dotdeb.org"
  release "#{node[:debian][:release]}"
  repo    %w{all}
  gpg_key_id  "89DF5277"
  gpg_key_url "http://www.dotdeb.org/dotdeb.gpg"
end
