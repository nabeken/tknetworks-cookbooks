%w(snapshot_restore_create.sh snapshot_restore_destroy.sh).each do |f|
  template "/usr/local/bin/#{f}" do
    source "zfs_#{f}"
    mode  0755
    owner node.bacula.uid
    group node.bacula.gid
  end
end
