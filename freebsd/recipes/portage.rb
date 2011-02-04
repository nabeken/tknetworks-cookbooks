package "net/rsync" do
  source "ports"
end

cron "portage_sync" do
  command "/usr/local/bin/rsync rsync://ftp.nara.wide.ad.jp/gentoo-portage /srv/portage -aqP --delete"
  hour "*/4"
  minute 0
end
