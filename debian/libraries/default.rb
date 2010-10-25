class Chef
    module Debian
        def getRelease(platform_version)
            case platform_version
            when "squeeze/sid"
                "squeeze"
            when "5.0.6"
                "lenny"
            else
                "lenny"
            end
        end
    end
end
