define :ports_options, :options => nil do
  t = nil
  f = "/var/db/ports/#{params[:name]}/options"

  d = directory ::File.dirname(f) do
    action :create
    recursive true
    only_if do
      not ::File.exists?(::File.dirname(f))
    end
  end
  begin
    t = resources("template[#{f}]")
  rescue
    t = template f do
          owner "root"
          mode "0644"
          variables(:options => [])
          cookbook "freebsd"
          source "options"
        end
    params[:options].each do |opt|
      t.variables[:options].push opt
      Chef::Log.debug("Add #{opt} to #{params[:name]}")
    end
  end
  d.run_action(:create)
  t.run_action(:create)
end
