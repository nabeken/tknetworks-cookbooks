release = case platform_version
          when "squeeze/sid"
              "squeeze"
          when "5.0.6"
              "lenny"
          else
              "lenny"
          end

default[:debian][:release] = release
