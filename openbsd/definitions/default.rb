define :openbsd_interface,
       :inet  => nil,
       :inet6 => nil,
       :dev   => nil,
       :extra_commands => [] do

  if node[:platform] != "openbsd"
    raise "openvpn_interface is only for OpenBSD"
  end

  if params[:inet].nil? && params[:inet6].nil?
    raise "ipv4 or ipv6 address required"
  end

  if params[:dev].nil?
    raise "dev is required"
  end

  begin
    t = resources("template[/etc/hostname.#{params[:dev]}")
  rescue
    t = template "/etc/hostname.#{params[:dev]}" do
          owner "root"
          group node[:etc][:passwd][:root][:gid]
          mode  0640
          cookbook "openbsd"
          variables({
            :config => "#{node[:openvpn][:dir]}/#{params[:name]}.conf",
            :inet   => params[:inet],
            :inet6  => params[:inet6],
            :extra_commands => params[:extra_commands]
          })
          source "hostname.if"
        end
  end
end
