define :ports_options, :options => nil do
  t = nil
  f = "/var/db/ports/#{params[:name]}/options"
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
      Chef::Log.info("Add #{opt} to #{params[:name]}")
    end
  end
end
