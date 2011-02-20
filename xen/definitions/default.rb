define :xen_domU, :kernel => nil, :ramdisk => nil, :root => nil, :extra => nil, :cpus => nil, :vcpus => nil, :memory => 512, :bridge => "eth0", :macaddress => nil, :enable => true, :disk => nil do
  raise if params[:disk].nil?
  t = template "#{node.xen.config.dir}/domU/#{params[:name]}" do
    source "domU"

    [:kernel, :ramdisk, :root, :extra, :cpus, :vcpus].each do |e|
      if params[e].nil?
        params[e] = node[:xen][:domU][e]
      end
    end

    variables :memory  => params[:memory],
              :bridge  => params[:bridge],
              :mac     => params[:macaddress],
              :name    => params[:name],
              :extra   => params[:extra],
              :kernel  => params[:kernel],
              :ramdisk => params[:ramdisk],
              :cpus    => params[:cpus],
              :vcpus   => params[:vcpus],
              :disk    => params[:disk],
              :root    => params[:root],
              :name    => params[:name]
  end

  auto_domU = "#{node.xen.config.dir}/auto/#{params[:name]}"
  if params[:enable]
    link auto_domU do
      to "#{node.xen.config.dir}/domU/#{params[:name]}"
    end
  else
    File.unlink(auto_domU) if File.exist?(auto_domU)
  end
end
