include_recipe "bacula::dir"

%w(snapshot_create.sh snapshot_destroy.sh).each do |f|
  template "/usr/local/bin/#{f}" do
    source "zfs_#{f}"
    mode  0755
    owner node.bacula.uid
    group node.bacula.gid
  end
end

template "#{node.bacula.config_dir}/bacula-dir.conf.d/zfs_snapshot.conf" do
  source "bacula-dir/zfs_snapshot.conf"
  mode 0755
  owner node.bacula.uid
  group node.bacula.gid
  notifies :restart, resources(:service => "bacula-dir")
  variables :zfsnames                => node.bacula.zfs.snapshots,
            :maximum_concurrent_jobs => node.bacula.maximum_concurrent_jobs
end
