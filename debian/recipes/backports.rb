return if node[:platform] != "debian"

include_recipe "debian"

debian_aptline "backports" do
  url  "http://backports.debian.org/debian-backports"
  release "#{node[:debian][:release]}-backports"
  repo %w{main}
end
