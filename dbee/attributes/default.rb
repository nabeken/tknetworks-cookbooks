default[:dbee][:dir] = "/usr/local/dbee"
default[:dbee][:ffmpeg_deb] = "http://..."
default[:dbee][:api_url] = "http://..."
default[:dbee][:material_baseurl] = "http://..."
default[:dbee][:http_user] = "user"
default[:dbee][:http_password] = "password"
default[:dbee][:rake] = "rake1.9.1"
default[:dbee][:ca_dir] = "/etc/ssl/certs"
default[:dbee][:dav_baseurl] = "http://..."
default[:dbee][:output_dir] = "/tmp/encode"
default[:dbee][:gem_dir] = "/var/lib/gems/1.9.1"

packages = []

case platform
when "debian"
  packages.concat %w{
    ruby1.9.1-full
    git-core
    tmux
    build-essential
    libxml2-dev
    libxslt-dev
    libfaac0
    libmp3lame0
    libopencore-amrnb0
    libopencore-amrwb0
    libsdl1.2debian-all
    libtheora0
    libva1
    libvdpau1
    libvorbis0a
    libx11-6
    libxfixes3
    libxvidcore
    zlib1g
    libjack-jackd2-0
  }
end
default[:dbee][:packages] = packages

# aptline (loading from roles)
default[:dbee][:aptline][:url] = ""
default[:dbee][:aptline][:path] = ""
default[:dbee][:aptline][:repo] = []
