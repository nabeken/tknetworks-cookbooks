release = case platform_version
          when "squeeze/sid"
              "squeeze"
          when /^5\./
              "lenny"
          when /^6\./
              "squeeze"
          else
              raise "Unknown codename"
          end

default[:debian][:release] = release
