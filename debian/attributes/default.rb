release = case platform_version
          when "squeeze/sid"
              "squeeze"
          when /^5\./
              "lenny"
          when /^6\./
              "squeeze"
          else
             "unknown"
          end

default[:debian][:release] = release
default[:debian][:arch] = node[:kernel][:machine] == "x86_64" ?  "amd64" : node[:kernel][:machine]
default[:debian][:deb_archives] = "/var/cache/apt/archives"
