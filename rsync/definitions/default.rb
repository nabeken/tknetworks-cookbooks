rsync_module_args = [
  :path     => nil,
  :comment  => nil,
  :readonly => false,
  :deny     => nil,
  :allow    => nil,
  :exclude  => nil,
]

define :rsync_module, *rsync_module_args do
  t = nil
  begin
    t = resources(:template => node.rsync.server.config)
  rescue
    t = template node.rsync.server.config do
      source "rsyncd.conf"
      owner  "root"
      mode   "0644"
      variables :config => {}
    end
  end

  t.variables[:config][params[:name]] = Mash.new if t.variables[:config][params[:name]].nil?
  rsync_module_args.first.each do |key, val|
    t.variables[:config][params[:name]][key] = params[key]
  end
end
