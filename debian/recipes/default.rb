return if platform != "debian"

debian_aptline "security" do
    url  "http://security.debian.org/"
    path "/updates"
    repo %w{main contrib}
end

debian_aptline "base" do
    url  "http://cdn.debian.net/debian"
    repo %w{main contrib nonfree}
end

# opscode's cool repos
debian_aptline "opscode"
    url  "http://apt.opscode.com"
    repo %w{main}
end

# remove execute bits
file "/etc/cron.daily/find" do
    mode 0444
end
