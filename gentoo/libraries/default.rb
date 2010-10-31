class Chef
    module Gentoo
        def getChost(node)
            case node.kernel.machine
            when "x86_64"
                "x86_64-pc-linux-gnu"
            when "i686"
                "i686-gentoo-linux-gnu"
            end
        end

        def getCflags(node)
            "-march=native -O3 -pipe"
        end

        def getKeywords(node)
            case node.kernel.machine
            when "x86_64"
                "amd64"
            when "i686"
                "x86"
            end
        end

        def getMirrors(node)
            "http://distfiles.gentoo.org"
        end

        def getSync(node)
            "rsync://rsync.gentoo.org/gentoo-portage"
        end

        def getMakeopts(node)
            j = node.cpu.total + 1
            return "-j#{j}"
        end
    end
end
