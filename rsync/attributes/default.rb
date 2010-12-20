pkg = "rsync"

case platform
when "gentoo"
  pkg = "net-misc/rsync"
when "freebsd"
  pkg = "net/rsync"
end

default[:rsync][:package] = pkg
