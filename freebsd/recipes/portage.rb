package "net/rsync" do
  source "ports"
end

cron "portage_sync" do
  command "/usr/local/bin/rsync rsync://rsync.jp.gentoo.org/gentoo-portage /srv/portage -aqP --delete"
  hour "*/4"
  minute 0
end
