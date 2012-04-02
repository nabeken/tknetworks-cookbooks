define :debian_aptline, :url => nil, :path => nil, :repo => nil, :release => nil do
  t = nil

  file = "sources.list.d/#{params[:name]}.list"

  begin
    t = resources(:template => "/etc/apt/#{file}")
  rescue
    t = template "/etc/apt/#{file}" do
          source "etc/apt/sources.list"
          owner "root"
          group "root"
          mode  0644
          variables :aptlines => []
          cookbook "debian"
          notifies :run, "execute[apt-get-update]", :immediately
    end
  end

  aptline = {}
  [:url, :path, :repo].each do |para|
      aptline[para] = params[para]
  end
  aptline[:release] = params[:release].nil? ? node.debian.release : params[:release]

  t.variables[:aptlines].push aptline

  Chef::Log.info("registering aptline #{params[:name]}")
end

define :debian_pinning, :pin => nil, :priority => 500 do
  t = nil
  file = "preferences.d/#{params[:name]}"

  begin
    t = resources(:template => "/etc/apt/#{file}")
  rescue
    t = template "/etc/apt/#{file}" do
          source "etc/apt/preference"
          owner "root"
          group "root"
          mode  0644
          cookbook "debian"
          variables :params => params
    end
  end
end
