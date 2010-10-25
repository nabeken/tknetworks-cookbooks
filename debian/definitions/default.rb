extend Chef::Debian

define :debian_aptline, :url => nil, :path => nil, :repo => nil do
    t = nil

    file = "sources.list.d/#{params[:name]}"

    begin
	t = resources(:template => "/etc/apt/#{file}")
    rescue
	t = template "/etc/apt/#{file}" do
	    source "etc/apt/sources.list"
	    owner "root"
	    group "root"
            mode  0644
	    variables :aptlines => [], :release => getRelease(node.platform_version)
	end
    end

    aptline = {}
    [:url, :path, :repo].each do |para|
        aptline[para] = params[para]
    end

    t.variables[:aptlines].push aptline

    Chef::Log.info("registering aptline #{params[:name]}")
end
